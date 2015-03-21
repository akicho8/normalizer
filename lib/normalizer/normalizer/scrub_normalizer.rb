module Normalizer
  class ScrubNormalizer < Base
    def process
      if @value
        @value.to_s.scrub((@params == true) ? "" : @params)
      end
    end
  end
end
