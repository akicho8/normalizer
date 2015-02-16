# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "../lib"
require "normalizer"

require "active_record"

ActiveRecord::Base.logger = nil
ActiveSupport::LogSubscriber.colorize_logging = false
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Schema.define do
  create_table :articles do |t|
    t.string :name
  end
end

ActiveSupport.on_load(:active_record) { include Normalizer::Model }
Normalizer.logger = ActiveSupport::Logger.new(STDOUT)

class Article < ActiveRecord::Base
  normalize_default_options.update(:strip_tags => true)
  with_options(:hankaku => true) do |o|
    o.normalize :name, :strip => true
  end
end

record = Article.create!(:name => "<i>ａｌｉｃｅ</i>　")
record.name                     # => "alice"
# >> Normalize process at 1/3 by hankaku          "<i>ａｌｉｃｅ</i>　" => "<i>alice</i> "
# >> Normalize process at 2/3 by strip_tags       "<i>alice</i> " => "alice "
# >> Normalize process at 3/3 by strip            "alice " => "alice"
# >> Normalize finish article.name "<i>ａｌｉｃｅ</i>　" => "alice"
