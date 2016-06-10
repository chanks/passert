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

      if message.is_a?(String)
        raise AssertionFailed, message
      else
        raise message
      end
    end
  end
end
