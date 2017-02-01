require 'spec_helper.rb'
require 'theaters'

RSpec.describe Theaters::MovieCollection do
  subject(:films) { Theaters::MovieCollection.new('./spec/movies.txt') }

  describe 'movies has a 4 types' do
    it_should_behave_like 'movie type', 1900..1945, Theaters::Movie::Ancient
    it_should_behave_like 'movie type', 1946..1968, Theaters::Movie::Classic
    it_should_behave_like 'movie type', 1969..2000, Theaters::Movie::Modern
    it_should_behave_like 'movie type', 2001..Time.new.year, Theaters::Movie::New
  end

  describe 'filter' do
    it 'by title' do
      titles = films.filter(title: 'The Terminator').map(&:title)
      expect(titles).to not_be_empty.and all match 'The Terminator'
    end

    it 'by year' do
      years = films.filter(year: 1980).map(&:year)
      expect(years).to not_be_empty.and all eq 1980
    end

    it 'by country' do
      countries = films.filter(country: 'UK').map(&:country)
      expect(countries).to not_be_empty.and all match 'UK'
    end

    it 'by genre' do
      genres = films.filter(genre: 'Comedy').map(&:genre)
      expect(genres).to not_be_empty.and all include 'Comedy'
    end

    it 'by duration' do
      durations = films.filter(duration: 180).map(&:duration)
      expect(durations).to not_be_empty.and all eq 180
    end

    it 'by producer' do
      producers = films.filter(producer: 'Christopher Nolan').map(&:producer)
      expect(producers).to not_be_empty.and all match 'Christopher Nolan'
    end

    it 'by actors' do
      actors = films.filter(actors: 'Alexandre Rodrigues').map(&:actors)
      expect(actors).to not_be_empty.and all include 'Alexandre Rodrigues'
    end
  end

  describe 'collection have enumerable methods' do
    it 'use for movies' do
      expect(films.map(&:class).map(&:superclass)).to all eq Theaters::Movie
    end

    it 'methods' do
      expect(films.methods).to include :map, :select, :reject
    end
  end
end
