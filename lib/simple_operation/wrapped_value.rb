class SimpleOperation
  class WrappedValue < SimpleDelegator

    attr_reader :delegate_sd_obj

    def on_success
      self
    end

    def on_failure(reason = nil)
      self
    end

    alias_method :unwrap, :delegate_sd_obj

  end
end
