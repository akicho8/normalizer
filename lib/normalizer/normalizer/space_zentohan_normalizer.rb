module Normalizer
  class SpaceZentohanNormalizer < Base
    def process
      if @value
        @value.to_s.gsub(/#{[0x3000].pack('U')}/, " ")
      end
    end
  end
end
