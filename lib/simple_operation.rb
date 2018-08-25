require_relative './simple_operation/version'
require_relative './simple_operation/success'
require_relative './simple_operation/failure'
require_relative './simple_operation/builder'

class SimpleOperation

  def self.new(*args, &block)
    Builder::SplatOperation.build(args, &block)
  end

end
