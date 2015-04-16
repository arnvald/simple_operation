require_relative './simple_operation/version'

class SimpleOperation

  def self.new(*args)
    args_list_with_nils = args.empty? ? '' : "#{args.join('=nil,')}=nil"
    Class.new do
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

      code
    end
  end

end
