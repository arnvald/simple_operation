class SimpleOperation
  module Builder
    module StandardOperation

      def self.build(&block)
        Class.new do

          class_eval(&block) if block_given?

          def perform
            call
          end

          private

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
  end
end
