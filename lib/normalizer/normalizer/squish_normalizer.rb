module Normalizer
  class SquishNormalizer < Base
    def process
      if @value
        @value.to_s.squish
      end
    end
  end
end
