module Normalizer
  class EnterNormalizer < Base
    def process
      if @value
        require 'nkf'
        NKF::nkf("--unix -w", @value.to_s)
      end
    end
  end
end
