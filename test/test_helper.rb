require "test/unit"
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'normalizer'
require 'active_record'

ActiveSupport.on_load(:active_record) { include Normalizer::Model }
# Normalizer.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
