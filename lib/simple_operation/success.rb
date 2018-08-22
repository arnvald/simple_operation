require_relative './wrapped_value'

class SimpleOperation
  module Success

    def self.generate(*args)
      Struct.new(*args) do
        include InstanceMethods
      end
    end

    module InstanceMethods

      def on_success
        WrappedValue.new(yield self)
      end

      def on_failure(reason = nil)
        self
      end

      def success?
        true
      end

      def failure?
        false
      end

      def unwrap
        self
      end

    end

  end
end
