require 'spec_helper.rb'
require_relative '../movies.rb'

RSpec.describe Theaters::ModernMovie do
  before { @films = Theaters::MovieCollection.new('./spec/movies.txt') }
  subject(:movie) { @films.filter(year: 1969..2000)[0] }

  its(:to_s) { should eq "The Shawshank Redemption - современное кино, играют: Tim Robbins, Morgan Freeman, Bob Gunton" }

  it "should have a price" do
    expect(movie.price).to eq 3
  end

  its(:period) { should eq :modern }
end
