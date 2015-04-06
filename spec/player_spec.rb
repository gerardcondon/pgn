require "rspec"
require "rspec/its"
require_relative "../lib/player"

# really simple test file to check that rspec is working
describe "The Player" do
  subject { Player.new(name: "Bob", elo:1234) }

  its(:name) { should eq("Bob") }
  its(:elo) { should eq(1234) }
end