require 'passert'

AssertionFailed = Passert::AssertionFailed

module Kernel
  def assert(*args, &block)
    Passert.assert(*args, &block)
  rescue => e
    # Remove this method from the backtrace, since it's not helpful.
    e.backtrace.shift
    raise e
  end
end
