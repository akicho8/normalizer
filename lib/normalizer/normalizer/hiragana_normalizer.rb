require "nkf"

module Normalizer
  class HiraganaNormalizer < Base
    def process
      if @value
        NKF::nkf("--hiragana -w", @value.to_s)
      end
    end
  end
end
