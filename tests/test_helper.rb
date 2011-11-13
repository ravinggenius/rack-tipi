$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

require 'minitest/autorun'
#require 'ruby-debug' # http://blog.wyeworks.com/2011/11/1/ruby-1-9-3-and-ruby-debug

class TestHelper < MiniTest::Unit::TestCase
end
