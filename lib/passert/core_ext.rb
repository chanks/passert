require 'passert'

AssertionFailed = Passert::AssertionFailed

module Kernel
  def assert(*args, &block)
    Passert.assert(*args, &block)
  end
end
