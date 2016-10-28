require 'spec_helper.rb'
require_relative '../movies.rb'

RSpec.describe ClassicMovie do
  before { @films = MovieCollection.new('./spec/movies.txt') }
  subject(:movie) { @films.filter(year: 1946..1968)[0] }

  its(:to_s) { should eq "12 Angry Men - классический фильм, режиссер Sidney Lumet(еще 2 его фильмов в списке)" }

  it "should have a price" do
    expect(movie.class::PRICE).to eq 1.5
  end

  its(:period) { should eq :classic }
end
