require "nkf"

module Normalizer
  class HankakuNormalizer < Base
    def process
      if @value
        NKF::nkf("-wZ1", @value.to_s)
      end
    end
  end
end
