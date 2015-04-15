$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simple_operation'
require 'minitest/autorun'

class SimpleOperationTest < Minitest::Test

  def test_runs_correctly
    assert SimpleOperation.new(:login)
  end

  def test_has_no_public_readers
    assert_raises(NoMethodError) { object.login }
  end

  def test_has_private_readers
    assert object.send(:login)
  end

  def test_reader_is_assigned
    assert_equal 'Arnvald', object.send(:login)
  end

  def test_reader_is_assigned_default_value
    assert_equal klass.new.send(:login), nil
  end

  def test_instance_has_call_method
    assert object.respond_to?(:call)
  end

  def test_class_has_call_method
    assert klass.respond_to?(:call)
  end

  def test_class_call_runs_instances_call
    assert klass.('Arnvald')
    refute klass.('Grzegorz')
  end


  def object
    klass.new('Arnvald')
  end

  def klass
    FindUser
  end

  class FindUser < SimpleOperation.new(:login)
    def call
      login == 'Arnvald'
    end
  end

end
