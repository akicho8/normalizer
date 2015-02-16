require "nkf"

module Normalizer
  class KatakanaNormalizer < Base
    def process
      if @value
        NKF::nkf("--katakana -w", @value.to_s)
      end
    end
  end
end
