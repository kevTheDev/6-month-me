require 'rubygems'
require 'sinatra'
require 'sinatra/test/unit'
require 'init'

class InitTest < Test::Unit::TestCase

  def test_my_default
    get_it '/'
    assert_equal 'Hello world!', @response.body
  end

end