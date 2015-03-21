# -*- coding: utf-8 -*-
require 'test_helper'

ActiveRecord::Schema.define do
  create_table :articles, :force => true do |t|
    t.string :name
  end
end

class Article < ActiveRecord::Base
  normalize_default_options.update(:strip_tags => true)
  with_options(:hankaku => true) do |o|
    o.normalize :name
  end
end

class TestNormalizer < Test::Unit::TestCase
  test "normalze" do
    assert_nil Normalizer.normalize("<i></i>", :strip_tags => true, :blank_to_nil => true)
  end

  test "attribute_normalze" do
    assert_equal " (A)!  - ", arg_test("　（Ａ）！　　—　", :hankaku => true)
    assert_equal " (A)!  — ", arg_test("　（Ａ）！　　—　", :multi_byte => true)
    assert_equal " （Ａ）！  — ", arg_test("　（Ａ）！　　—　", :space_zentohan => true)
    assert_equal "アア", arg_test("あア", :katakana => true)
    assert_equal "ああ", arg_test("あア", :hiragana => true)
    assert_equal "A", arg_test("<i>A</i>", :strip_tags => true)
    assert_equal "AB", arg_test("A\xffB", :scrub => true)
    assert_equal "あ\nあ\n", arg_test("あ\r\nあ\r\n", :enter => true)
    assert_equal "A  A", arg_test(" A  A ", :strip => true)
    assert_equal "A A", arg_test(" A  A ", :squish => true)
    assert_equal "012", arg_test("012345", :truncate => 3)
    assert_equal nil, arg_test("\t", :blank_to_nil => true)
    assert_equal "[]", arg_test([], :to_s => true) # 入力は文字列という前提なのでこういうケースはないかもしれん
  end

  # default は特別で changes を見ない。そして一番最後に実行。
  # 新しく値をセットするため正規化の意味と違ってくるのでこの機能は要検討。
  # nil なので "" をセットする
  test "default" do
    assert_equal "", arg_test(nil, :default => "")
  end

  # ブロックを指定するとなんでもできる。ただし最後に実行。
  test "block" do
    # strip されたあとでブロックが作動していることを確認
    assert_equal "AA", arg_test(" A ", :strip => true, &proc{|v|v * 2})
    # ブロックのみを指定できる。これはほとんど実行タイミングが異なるだけのvalidates_each相当。
    assert_equal "12", arg_test("1-2", {}, &proc{|v|v.gsub("-", "")})
  end

  # 複合技。タグを取ると "" なので nil になる
  test "attribute_multi_normalze" do
    assert_nil arg_test("<i></i>", :strip_tags => true, :blank_to_nil => true)
  end

  # 暗黙のオプションが効いているのでタグを取ったあとで blank_to_nil が作動して nil になる
  test "normalize_default_options" do
    klass = my_mock(:strip_tags => true)
    klass.class_eval do
      normalize_default_options.update(:blank_to_nil => true)
    end
    assert_nil klass.new(:name => "<i></i>").tap{|e|e.valid?}.name
  end

  # モデルで暗黙指定した strip_tags と with_options で指定した hankaku の3つが作動して半角スペースになる
  test "with_options" do
    record = Article.new(:name => "<i>　</i>")
    record.valid?
    assert_equal " ", record.name
  end

  private

  def arg_test(str, args, &block)
    my_mock(args, &block).new(:name => str).tap{|e|e.valid?}.name
  end

  def my_mock(args, &block)
    Class.new(ActiveRecord::Base) do
      self.table_name = :articles
      normalize_default_options.clear
      normalize :name, args, &block
    end
  end
end
