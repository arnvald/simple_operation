class SimpleOperation
  module Builder
    module SplatOperation

      def self.build(args, &block)
        StandardOperation.build do
          class_eval(&block) if block_given?

          class_eval <<-code
            def self.call #{SplatOperation.args_with_nils(args)}
              new(#{args.join(',')}).call
            end

            def initialize #{SplatOperation.args_with_nils(args)}
              #{SplatOperation.args_for_setting_ivars(args)}
            end
          code

          private
            attr_reader(*args)

        end
      end

      private

        def self.args_with_nils(args)
          return '' if args.empty?
          args.map { |a| "#{a}=nil" }.join(", ")
        end

        # takes an array of arguments
        # returns a list of ivar setting instructions
        # args_for_setting_ivars(:a, :b)
        # "@a= a; @b= b"
        def self.args_for_setting_ivars(args)
          args.map { |a| "@#{a}= #{a}" }.join(';')
        end

    end
  end
end
