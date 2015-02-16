module Normalizer
  class MultiByteNormalizer < Base
    def process
      if @value
        @value.to_s.mb_chars.normalize.to_s
      end
    end
  end
end
