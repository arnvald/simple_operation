require_relative './wrapped_value'

class SimpleOperation
  module Failure

    def self.generate(*args)
      Struct.new(*args) do
        include InstanceMethods
      end
    end

    module InstanceMethods

      def on_success
        self
      end

      def on_failure(match_reason = nil)
        if match_reason.nil? || (respond_to?(:reason) && reason == match_reason)
          WrappedValue.new(yield self)
        else
          self
        end
      end

      def success?
        false
      end

      def failure?
        true
      end

      def unwrap
        self
      end

    end

  end
end
