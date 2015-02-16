module Normalizer
  class BlankToNilNormalizer < Base
    def process
      @value.presence
    end
  end
end
