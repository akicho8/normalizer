# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "../lib"
require "normalizer"
Normalizer.logger = ActiveSupport::Logger.new(STDOUT)

Normalizer.normalize("ｒｕｂｙ　ｏｎ　ｒａｉｌｓ", :hankaku => true) # => "ruby on rails"
Normalizer.normalize("ドラえもん", :katakana => true)                # => "ドラエモン"
Normalizer.normalize("ドラえもん", :hiragana => true)                # => "どらえもん"
Normalizer.normalize("<b>ドラえもん</b>", :strip_tags => true)       # => "ドラえもん"
Normalizer.normalize("ドラ\xffえもん", :scrub => true)               # => "ドラえもん"
Normalizer.normalize("ruby　on　rails", :space_zentohan => true)     # => "ruby on rails"
Normalizer.normalize("foo\r\nbar\r\n", :enter => true)               # => "foo\nbar\n"
Normalizer.normalize(" ドラえもん ", :strip => true)                 # => "ドラえもん"
Normalizer.normalize("  ruby  on  rails  ", :squish => true)         # => "ruby on rails"
Normalizer.normalize("ドラえもん", :truncate => 2)                   # => "ドラ"
Normalizer.normalize(" ", :blank_to_nil => true)                     # => nil
Normalizer.normalize(nil, :to_s => true)                             # => ""
# >> Normalize process at 1/1 by hankaku          "ｒｕｂｙ　ｏｎ　ｒａｉｌｓ" => "ruby on rails"
# >> Normalize process at 1/1 by katakana         "ドラえもん" => "ドラエモン"
# >> Normalize process at 1/1 by hiragana         "ドラえもん" => "どらえもん"
# >> Normalize process at 1/1 by strip_tags       "<b>ドラえもん</b>" => "ドラえもん"
# >> Normalize process at 1/1 by scrub            "ドラ\xFFえもん" => "ドラえもん"
# >> Normalize process at 1/1 by space_zentohan   "ruby　on　rails" => "ruby on rails"
# >> Normalize process at 1/1 by enter            "foo\r\nbar\r\n" => "foo\nbar\n"
# >> Normalize process at 1/1 by strip            " ドラえもん " => "ドラえもん"
# >> Normalize process at 1/1 by squish           "  ruby  on  rails  " => "ruby on rails"
# >> Normalize process at 1/1 by truncate         "ドラえもん" => "ドラ"
# >> Normalize process at 1/1 by blank_to_nil     " " => ""
# >> Normalize process at 1/1 by to_s             "" => ""
