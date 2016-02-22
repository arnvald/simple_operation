require_relative './simple_operation/version'

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

        def perform
          call
        end

        private
          #{args.map { |arg| "attr_reader :#{arg}" }.join(';') }

          def self.result(*args)
            @result_class = Struct.new(*args)
          end

          def result(*args)
            self.class.instance_variable_get(:@result_class).new(*args)
          end

      code
    end
  end

end
