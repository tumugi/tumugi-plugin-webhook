require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'test/unit'
require 'test/unit/rr'

require 'tumugi'
require 'tumugi/test/helper'
include Tumugi::Test::Helpers

require 'fileutils'
FileUtils.mkdir_p('tmp')
