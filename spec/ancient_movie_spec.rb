require 'spec_helper.rb'
require 'theaters'

RSpec.describe Theaters::Movie::Ancient do
  let(:films) { Theaters::MovieCollection.new('./spec/movies.txt') }
  subject(:movie) { films.filter(year: 1900..1945).first }

  its(:to_s) { should eq 'Casablanca - старый фильм (1942 год)' }

  it 'should have a price' do
    expect(movie.price).to eq 1
  end

  its(:period) { should eq :ancient }
end
