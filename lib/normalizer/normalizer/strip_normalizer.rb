module Normalizer
  class StripNormalizer < Base
    def process
      if @value
        @value.to_s.strip
      end
    end
  end
end
