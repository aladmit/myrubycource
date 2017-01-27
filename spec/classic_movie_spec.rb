require 'spec_helper.rb'
require 'theaters'

RSpec.describe Theaters::ClassicMovie do
  before { @films = Theaters::MovieCollection.new('./spec/movies.txt') }
  subject(:movie) { @films.filter(year: 1946..1968)[0] }

  its(:to_s) { should eq '12 Angry Men - классический фильм, режиссер Sidney Lumet(еще 2 его фильмов в списке)' }

  it 'should have a price' do
    expect(movie.price).to eq 1.5
  end

  its(:period) { should eq :classic }
end
