$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simple_operation'
require 'minitest/autorun'

class FailureTest < Minitest::Test

  FakeFailure = SimpleOperation::Failure.generate(:value)
  FakeReasonFailure = SimpleOperation::Failure.generate(:reason)

  def test_runs_correctly
    assert SimpleOperation::Failure.generate(:value)
  end

  def test_has_correct_attributes
    klass = SimpleOperation::Failure.generate(:name, :email)
    instance = klass.new("Tom", "tom@tomtomtomtom.com")

    assert_equal "Tom", instance.name
    assert_equal "tom@tomtomtomtom.com", instance.email
  end

  def test_is_not_successful
    refute FakeFailure.new("123").success?
  end

  def test_is_failure
    assert FakeFailure.new("123").failure?
  end

  def test_returns_wrapped_value_on_failure
    result = FakeFailure.new("123").on_failure { |s| s.value * 3 }

    assert_equal SimpleOperation::WrappedValue.new("123123123"), result
  end

  def test_returns_wrapped_value_on_matching_reason
    failure = FakeReasonFailure.new(:wrong_id)
    result = failure.on_failure(:wrong_id) { |s| "this is #{s.reason}" }

    assert_equal SimpleOperation::WrappedValue.new("this is wrong_id"), result
  end

  def test_returns_self_on_non_matching_reason
    failure = FakeReasonFailure.new(:wrong_name)
    result = failure.on_failure(:wrong_id) { |s| "this is #{s.reason}" }

    assert_equal result, failure
  end

  def test_returns_self_on_success
    failure = FakeFailure.new("123")
    result = failure.on_success { |s| s.value * 4 }

    assert_equal failure, result
  end

  def test_unwraps_self
    failure = FakeFailure.new("123")

    assert_equal failure, failure.unwrap
  end
end

