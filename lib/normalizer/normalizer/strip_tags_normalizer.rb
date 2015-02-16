require "rails/deprecated_sanitizer/html-scanner"
require "active_support/core_ext/string/output_safety"
require "active_support/core_ext/object/try"

module Normalizer
  class StripTagsNormalizer < Base
    def process
      if @value
        HTML::FullSanitizer.new.sanitize(@value.to_s).try(:html_safe)
      end
    end
  end
end
