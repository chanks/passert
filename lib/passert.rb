require 'passert/version'

module Passert
  class AssertionFailed < StandardError; end

  class << self
    def assert?(*args)
      pass, _, _ = _check_assertion(*args)
      pass
    end

    def assert(*args)
      pass, expected, actual = _check_assertion(*args)
      return actual if pass

      message =
        if block_given?
          yield
        elsif expected
          "Expected #{expected.inspect}, got #{actual.inspect}!"
        else
          "Assertion failed!"
        end

      # Remove this method from the backtrace, to make errors clearer.
      backtrace = caller

      case message
      when Exception
        raise message.class, message.message, backtrace
      else
        raise AssertionFailed, message.to_s, backtrace
      end
    end

    private

    def _check_assertion(first, second = (second_omitted = true; nil))
      # Want to support:
      #   assert(x)                       # Truthiness.
      #   assert(thing, other)            # Trip-equals.
      #   assert([thing1, thing2], other) # Multiple Trip-equals.

      if second_omitted
        expected = nil
        actual   = first
      else
        expected = first
        actual   = second
      end

      pass =
        if second_omitted
          actual
        elsif expected.is_a?(Array)
          expected.any? { |k| k === actual }
        else
          expected === actual
        end

      [!!pass, expected, actual]
    end
  end
end
