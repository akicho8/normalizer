module Normalizer
  class TruncateNormalizer < Base
    def process
      if @value
        @value.to_s.truncate(@params, :omission => "")
      end
    end
  end
end
