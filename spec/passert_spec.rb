require 'spec_helper'

class PassertSpec < Minitest::Spec
  it "should have a version number" do
    refute_nil ::Passert::VERSION
  end
end
