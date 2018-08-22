$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simple_operation'
require 'minitest/autorun'

class SuccessTest < Minitest::Test

  FakeSuccess = SimpleOperation::Success.generate(:value)

  def test_runs_correctly
    assert SimpleOperation::Success.generate(:value)
  end

  def test_has_correct_attributes
    klass = SimpleOperation::Success.generate(:name, :email)
    instance = klass.new("Tom", "tom@tomtomtomtom.com")

    assert_equal "Tom", instance.name
    assert_equal "tom@tomtomtomtom.com", instance.email
  end

  def test_is_successful
    assert FakeSuccess.new("123").success?
  end

  def test_is_not_failure
    refute FakeSuccess.new("123").failure?
  end

  def test_returns_wrapped_value_on_success
    result = FakeSuccess.new("123").on_success { |s| s.value * 3 }

    assert_equal SimpleOperation::WrappedValue.new("123123123"), result
  end

  def test_returns_self_on_failure
    success = FakeSuccess.new("123")
    result = success.on_failure { |s| s.value * 4 }

    assert_equal success, result
  end

  def test_unwraps_self
    success = FakeSuccess.new("123")

    assert_equal success, success.unwrap
  end
end
