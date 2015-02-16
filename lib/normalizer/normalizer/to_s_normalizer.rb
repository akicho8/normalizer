module Normalizer
  class ToSNormalizer < Base
    def process
      @value.to_s
    end
  end
end
