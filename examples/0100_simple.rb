# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "../lib"
require "normalizer"
Normalizer.logger = ActiveSupport::Logger.new(STDOUT)
Normalizer.normalize("<i>　</i>", :strip_tags => true, :hankaku => true) # => " "
# >> Normalize process at 1/2 by hankaku          "<i>　</i>" => "<i> </i>"
# >> Normalize process at 2/2 by strip_tags       "<i> </i>" => " "
