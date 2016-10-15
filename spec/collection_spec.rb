require 'spec_helper.rb'
require_relative '../movies.rb'

RSpec.describe MovieCollection do
  subject(:films) { MovieCollection.new('./spec/movies.txt') }

  describe 'movies has a 4 types' do
    
    it 'ancient movie' do
      array_of_classes = films.filter(year: 1900..1945).collect(&:class).uniq
      expect(array_of_classes.size).to eq 1
      expect(array_of_classes[0]).to eq AncientMovie
    end

    it 'classic movie' do
      array_of_classes = films.filter(year: 1946..1968).collect(&:class).uniq
      expect(array_of_classes.size).to eq 1
      expect(array_of_classes[0]).to eq ClassicMovie
    end

    it 'modern movie' do
      array_of_classes = films.filter(year: 1969..2000).collect(&:class).uniq
      expect(array_of_classes.size).to eq 1
      expect(array_of_classes[0]).to eq ModernMovie
    end

    it 'new movie' do
      array_of_classes = films.filter(year: 2001..Time.new.year).collect(&:class).uniq
      expect(array_of_classes.size).to eq 1
      expect(array_of_classes[0]).to eq NewMovie
    end
  end
end
