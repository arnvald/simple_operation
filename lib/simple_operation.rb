require_relative './simple_operation/version'
require_relative './simple_operation/success'
require_relative './simple_operation/failure'

class SimpleOperation

  def self.new(*args, &block)
    args_list_with_nils = args.empty? ? '' : "#{args.join('=nil,')}=nil"
    Class.new do
      class_eval(&block) if block_given?

      class_eval <<-code
        def self.call #{args_list_with_nils}
          new(#{args.join(',')}).call
        end

        def initialize #{args_list_with_nils}
          #{args.map { |arg| "@#{arg}= #{arg}" }.join(';') }
        end
      code

      def perform
        call
      end

      private
        attr_reader(*args)

        def self.result(*args)
          @result_class = Struct.new(*args)
        end

        def self.success(*args)
          @success_class = Success.generate(*args)
        end

        def self.failure(*args)
          @failure_class = Failure.generate(*args)
        end

        def result(*args)
          self.class.instance_variable_get(:@result_class).new(*args)
        end

        def success(*args)
          self.class.instance_variable_get(:@success_class).new(*args)
        end

        def failure(*args)
          self.class.instance_variable_get(:@failure_class).new(*args)
        end

        alias_method :Result, :result
        alias_method :Success, :success
        alias_method :Failure, :failure
    end
  end

end
