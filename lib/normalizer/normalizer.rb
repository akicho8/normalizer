# -*- coding: utf-8 -*-
# require "normalizer/version"
#
require "active_support/core_ext/class/subclasses"
require "active_support/core_ext/module/concerning"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/string"
require "active_support/core_ext/class/attribute"
require "active_support/logger"

module Normalizer
  mattr_accessor :logger

  mattr_accessor :default_options
  self.default_options = {
    # :strip        => true, # すべての処理に strip を適用する場合
    # :blank_to_nil => true, # すべての処理に blank_to_nil を適用する場合
  }

  class Base
    def initialize(*args)
      @value, @params = *args
    end

    def process
      raise NotImplementedError, "#{__method__} is not implemented"
    end
  end

  mattr_accessor :normalizer_keys
  self.normalizer_keys = [
    :hankaku,
    :katakana,
    :hiragana,
    :strip_tags,
    :multi_byte,
    :space_zentohan,
    :enter,
    :strip,
    :squish,
    :truncate,
    :blank_to_nil,
    :to_s,
  ]

  #
  # どこからでも使えるメソッド
  #
  #   p Normalizer.normalize("<i></i>", :strip_tags => true, :blank_to_nil => true) #=> nil
  #
  def self.normalize(dirty_value, options = {}, &block)
    options.assert_valid_keys(*Normalizer.normalizer_keys)
    options = options.sort_by {|key, *| Normalizer.normalizer_keys.index(key) }
    keys = options.find_all {|_, val| val }
    value = keys.each.with_index.inject(dirty_value) do |dirty_value, ((key, params), i)|
      file_path = "normalizer/#{key}_normalizer"
      require "#{__dir__}/#{file_path}"
      value = file_path.classify.constantize.new(dirty_value, params).process
      if Normalizer.logger
        logger.debug "Normalize process at #{i.next}/#{keys.size} by #{key.to_s.ljust(16)} #{dirty_value.to_s.truncate(50).inspect} => #{value.to_s.truncate(50).inspect}"
      end
      value
    end
    if block_given?
      value = block.call(value)
    end
    value
  end
end
