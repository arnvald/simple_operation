class SimpleOperation
  module Builder
    class KeywordsOperation

      def self.build(args, &block)
        StandardOperation.build do
          class_eval(&block) if block_given?

          class_eval <<-code
            def self.call #{KeywordsOperation.args_for_definition(args)}
              new(#{KeywordsOperation.args_for_calling_initializer(args)}).call
            end

            def initialize #{KeywordsOperation.args_for_definition(args)}
              #{KeywordsOperation.args_for_setting_ivars(args)}
            end
          code

          private
            attr_reader(*args.keys)
        end
      end

      # takes a hash of arguments
      # returns a string
      # args_for_definition(a: 1, b: "str")
      # "a: 1, b: \"str\""
      def self.args_for_definition(args)
        args.map { |k,v| "#{k}: #{wrap_value(v)}" }.join(", ")
      end

      # takes a hash of arguments
      # returns a string
      # args_for_calling_initializer(a: 1, b: "str")
      # "a: a, b: b"
      def self.args_for_calling_initializer(args)
        args.map {|k, _| "#{k}: #{k}" }.join(", ")
      end

      # takes a hash of arguments
      # returns a list of ivar setting instructions
      # args_for_setting_ivars(a: 1, b: "str")
      # "@a= a; @b= b"
      def self.args_for_setting_ivars(args)
        args.map { |k, _| "@#{k}= #{k}" }.join(';')
      end

      # Wraps string and symbol so that inside the string it
      # looks like a valid Ruby syntax
      # wrap_value("a") => "\"a\""
      # wrap_value(:a) => ":a"
      # wrap_value(123) => 123
      def self.wrap_value(value)
        if value.is_a?(String) then "'#{value}'"
        elsif value.is_a?(Symbol) then ":#{value}"
        else value
        end
      end

    end
  end
end
