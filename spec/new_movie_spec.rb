require 'spec_helper.rb'
require_relative '../movies.rb'

RSpec.describe NewMovie do
  before { @films = MovieCollection.new('./spec/movies.txt') }
  subject(:movie) { @films.filter(year: 2001...Time.new.year)[0] }

  its(:to_s) { should eq "The Dark Knight - новинка, вышло #{Time.new.year - movie.year} лет назад!" }

  it "should have a price" do
    expect(movie.class::PRICE).to eq 5
  end

  its(:period) { should eq :new }
end
