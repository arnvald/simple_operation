$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simple_operation'
require 'minitest/autorun'

class SimpleOperationTest < Minitest::Test

  def test_runs_correctly
    assert SimpleOperation.new(:login)
  end

  def test_runs_correctly_with_no_params
    assert SimpleOperation.new
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

  def test_instance_call_runs_correctly
    assert klass.new('Arnvald').()
    refute klass.new('Grzegorz').()
  end

  def test_perform_aliases_to_call
    assert klass.new('Arnvald').perform
    refute klass.new('Grzegorz').perform
  end

  def test_class_has_call_method
    assert klass.respond_to?(:call)
  end

  def test_class_call_runs_instances_call
    assert klass.('Arnvald')
    refute klass.('Grzegorz')
  end

  def test_returns_result
    assert result_klass.('').is_a? Struct
    assert result_klass.('').respond_to? :found
    assert result_klass.('Arnvald').found
    refute result_klass.('Grzegorz').found
  end


  def object
    klass.new('Arnvald')
  end

  def klass
    FindUser
  end

  def result_klass
    FindUserResult
  end

  class FindUser < SimpleOperation.new(:login)
    def call
      login == 'Arnvald'
    end
  end

  class FindUserResult < SimpleOperation.new(:login)
    result :found

    def call
      result(login == 'Arnvald')
    end
  end

end
