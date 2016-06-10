require 'spec_helper'

class PassertSpec < Minitest::Spec
  it "should have a version number" do
    refute_nil ::Passert::VERSION
  end

  it "#assert should return the argument if it is truthy, whether a block was passed or not" do
    called = false

    assert_equal        5, Passert.assert(5)
    assert_equal        5, Passert.assert(5) { called = true; "Expected 5" }
    assert_equal 'ferret', Passert.assert('ferret')
    assert_equal 'ferret', Passert.assert('ferret') { called = true; "Expected ferret" }

    assert_equal false, called
  end

  it "#assert should raise an AssertionFailed error if it is falsey and no block is given" do
    error = assert_raises(Passert::AssertionFailed) { Passert.assert(false) }
    assert_equal "Assertion failed!", error.message

    error = assert_raises(Passert::AssertionFailed) { Passert.assert(nil) }
    assert_equal "Assertion failed!", error.message
  end

  it "#assert should raise the block result if it is falsey and a block is given" do
    error = assert_raises(Passert::AssertionFailed) { Passert.assert(false) { "Custom message!" } }
    assert_equal "Custom message!", error.message

    error = assert_raises(Passert::AssertionFailed) { Passert.assert(nil) { "Custom message!" } }
    assert_equal "Custom message!", error.message

    error = assert_raises(Exception) { Passert.assert(false) { Exception.new("Custom message!") } }
    assert_equal "Custom message!", error.message

    error = assert_raises(Exception) { Passert.assert(nil) { Exception.new("Custom message!") } }
    assert_equal "Custom message!", error.message
  end

  it "#assert should return the second argument if the first argument === the second argument, whether a block was passed or not" do
    called = false

    assert_equal        5, Passert.assert(Fixnum, 5)
    assert_equal        5, Passert.assert(Fixnum, 5) { called = true; "Custom message!" }
    assert_equal 'ferret', Passert.assert(String, 'ferret')
    assert_equal 'ferret', Passert.assert(String, 'ferret') { called = true; "Custom message!" }
    assert_equal      nil, Passert.assert(NilClass, nil)
    assert_equal      nil, Passert.assert(NilClass, nil) { called = true; "Custom message!" }

    assert_equal false, called
  end

  it "#assert when the first argument is an array should pass if any of its elements === the second argument" do
    assert_equal true,     Passert.assert([TrueClass, FalseClass], true)
    assert_equal false,    Passert.assert([TrueClass, FalseClass], false)
    assert_equal 'ferret', Passert.assert([/erre/], 'ferret')

    error = assert_raises(Passert::AssertionFailed) { Passert.assert([/ERRE/, /ErRe/], 'ferret') }
    assert_equal "Expected [/ERRE/, /ErRe/], got \"ferret\"!", error.message
  end

  it "#assert should raise an AssertionFailed error if the first argument does not === the second argument and no block is given" do
    error = assert_raises(Passert::AssertionFailed) { Passert.assert(Fixnum, 'string') }
    assert_equal "Expected Fixnum, got \"string\"!", error.message

    error = assert_raises(Passert::AssertionFailed) { Passert.assert(String, 5) }
    assert_equal "Expected String, got 5!", error.message
  end

  it "#assert should raise an error with the block result if the first argument does not === the second argument and a block is given" do
    error = assert_raises(Passert::AssertionFailed) { Passert.assert(Fixnum, 'string') { "Custom message!" } }
    assert_equal "Custom message!", error.message

    error = assert_raises(Passert::AssertionFailed) { Passert.assert(String, 5) { "Custom message!" } }
    assert_equal "Custom message!", error.message

    error = assert_raises(Exception) { Passert.assert(Fixnum, 'string') { Exception.new("Custom message!") } }
    assert_equal "Custom message!", error.message

    error = assert_raises(Exception) { Passert.assert(String, 5) { Exception.new("Custom message!") } }
    assert_equal "Custom message!", error.message
  end
end
