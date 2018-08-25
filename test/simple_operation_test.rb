$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simple_operation'
require 'minitest/autorun'

class SimpleOperationTest < Minitest::Test

  def test_runs_correctly
    assert SimpleOperation.new(:login)
    assert SimpleOperation.new(login: nil)
  end

  def test_runs_correctly_with_no_params
    assert SimpleOperation.new
  end

  def test_has_no_public_readers
    assert_raises(NoMethodError) { object.login }
    assert_raises(NoMethodError) { keyword_object.login }
  end

  def test_has_private_readers
    assert object.send(:login)
    assert keyword_object.send(:login)
  end

  def test_reader_is_assigned
    assert_equal 'Arnvald', object.send(:login)
    assert_equal 'Arnvald', keyword_object.send(:login)
  end

  def test_reader_is_assigned_nil_by_default
    assert_nil klass.new.send(:login)
  end

  def test_reader_is_assigned_default_value
    assert_equal keyword_klass.new.send(:login), "DEFAULT"
  end

  def test_instance_has_call_method
    assert object.respond_to?(:call)
    assert keyword_object.respond_to?(:call)
  end

  def test_instance_call_runs_correctly
    assert klass.new('Arnvald').()
    refute klass.new('Grzegorz').()

    assert keyword_klass.new(login: 'Arnvald').()
    refute keyword_klass.new(login: 'Grzegorz').()
  end

  def test_perform_aliases_to_call
    assert klass.new('Arnvald').perform
    refute klass.new('Grzegorz').perform

    assert keyword_klass.new(login: 'Arnvald').perform
    refute keyword_klass.new(login: 'Grzegorz').perform
  end

  def test_class_has_call_method
    assert klass.respond_to?(:call)
    assert keyword_klass.respond_to?(:call)
  end

  def test_class_call_runs_instances_call
    assert klass.('Arnvald')
    refute klass.('Grzegorz')

    assert keyword_klass.(login: 'Arnvald')
    refute keyword_klass.(login: 'Grzegorz')
  end

  def test_returns_result
    assert result_klass.('').is_a? Struct
    assert result_klass.('').respond_to? :found
    assert result_klass.('Arnvald').found
    refute result_klass.('Grzegorz').found

    assert keyword_result_klass.(login: '').is_a? Struct
    assert keyword_result_klass.(login: '').respond_to? :found
    assert keyword_result_klass.(login: 'Arnvald').found
    refute keyword_result_klass.(login: 'Grzegorz').found
  end

  def test_returns_success
    assert success_failure_klass.('Arnvald').success?
    assert success_failure_klass.('Arnvald').user == {name: 'Grzegorz'}

    assert keyword_success_failure_klass.(login: 'Arnvald').success?
    assert keyword_success_failure_klass.(login: 'Arnvald').user == {name: 'Grzegorz'}
  end

  def test_returns_failure
    refute success_failure_klass.('').success?
    assert success_failure_klass.('').error = 'invalid login'

    refute keyword_success_failure_klass.(login: '').success?
    assert keyword_success_failure_klass.(login: '').error = 'invalid login'
  end

  def object
    klass.new('Arnvald')
  end

  def keyword_object
    keyword_klass.new(login: 'Arnvald')
  end

  def klass
    FindUser
  end

  def keyword_klass
    KeyWordFindUser
  end

  def result_klass
    FindUserResult
  end

  def keyword_result_klass
    KeywordFindUserResult
  end

  def success_failure_klass
    FindUserSuccessFailure
  end

  def keyword_success_failure_klass
    KeywordFindUserSuccessFailure
  end

  FindUser = SimpleOperation.new(:login) do
    def call
      login == 'Arnvald'
    end
  end

  KeyWordFindUser = SimpleOperation.new(login: "DEFAULT") do
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

  class KeywordFindUserResult < SimpleOperation.new(login: "DEFAULT")
    result :found

    def call
      result(login == 'Arnvald')
    end
  end

  class FindUserSuccessFailure < SimpleOperation.new(:login)
    success :user
    failure :error

    def call
      if login == 'Arnvald'
        Success({name: "Grzegorz"})
      else
        Failure("invalid login")
      end
    end
  end

  class KeywordFindUserSuccessFailure < SimpleOperation.new(login: "DEFAULT")
    success :user
    failure :error

    def call
      if login == 'Arnvald'
        Success({name: "Grzegorz"})
      else
        Failure("invalid login")
      end
    end
  end

end
