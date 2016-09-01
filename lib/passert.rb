require 'passert/version'

module Passert
  class AssertionFailed < StandardError; end

  class << self
    def assert(first, second = (second_omitted = true; nil))
      # Want to support:
      #   assert(x)                       # Truthiness.
      #   assert(thing, other)            # Trip-equals.
      #   assert([thing1, thing2], other) # Multiple Trip-equals.

      if second_omitted
        comparison = nil
        truth      = first
      else
        comparison = first
        truth      = second
      end

      pass =
        if second_omitted
          truth
        elsif comparison.is_a?(Array)
          comparison.any? { |k| k === truth }
        else
          comparison === truth
        end

      return truth if pass

      message =
        if block_given?
          yield
        elsif comparison
          "Expected #{comparison.inspect}, got #{truth.inspect}!"
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
  end
end
