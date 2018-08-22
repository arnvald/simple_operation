$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simple_operation'
require 'minitest/autorun'

class WrappedValueTest < Minitest::Test

  def test_runs_correctly
    assert SimpleOperation::WrappedValue.new("A")
  end

  def test_returns_self_on_success
    value = SimpleOperation::WrappedValue.new("A")
    assert_equal value, (value.on_success { |v| nil })
  end

  def test_returns_self_on_failure
    value = SimpleOperation::WrappedValue.new("A")
    assert_equal value, (value.on_failure { |v| nil })
  end

  def test_unwraps_value
    value = SimpleOperation::WrappedValue.new("A")
    assert_equal "A", value.unwrap
  end

end
