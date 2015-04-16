$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simple_operation'
require 'simple_operation/ext'
require 'minitest/autorun'

class SimpleOperationExtTest < Minitest::Test

  def test_creates_new_class
    assert SimpleOperation(:login).is_a? Class
  end

end
