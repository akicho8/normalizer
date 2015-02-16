module Normalizer
  class Railtie < Rails::Engine
    initializer "normalizer" do
      ActiveSupport.on_load(:active_record) { include Normalizer::Model }
      Normalizer.logger ||= Rails.logger
    end
  end
end
