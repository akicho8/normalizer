# -*- coding: utf-8 -*-

module Normalizer
  class SlugNormalizer < Base
    def process
      if @value
        begin
          require "babosa"
        rescue LoadError
          raise "Gemfile に gem 'babosa' を追加してください"
        end
        if @value.to_s.respond_to?(:to_slug)
          @value.to_s.to_slug.normalize.to_s
        end
      end
    end
  end
end
