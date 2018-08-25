require_relative './simple_operation/version'
require_relative './simple_operation/success'
require_relative './simple_operation/failure'
require_relative './simple_operation/builder'

class SimpleOperation

  def self.new(*args, &block)
    if args.first.is_a?(Hash)
      Builder::KeywordsOperation.build(args.first, &block)
    else
      Builder::SplatOperation.build(args, &block)
    end
  end

end
