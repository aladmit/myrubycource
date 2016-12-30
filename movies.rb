require 'csv'
require './movie.rb'
require './ancient_movie.rb'
require './classic_movie.rb'
require './modern_movie.rb'
require './new_movie.rb'

module Theaters
  class MovieCollection
    include Enumerable

    FIELDS = %i(url title year country date genre duration stars producer actors).freeze

    def initialize(file = 'movies.txt')
      @films = CSV.read(file, col_sep: '|', headers: FIELDS).map do |line|
        line = line.to_h
        line[:year] = line[:year].to_i
        line[:date] = line[:date].split('-')
        line[:genre] = line[:genre].split(',')
        line[:duration] = line[:duration].to_i
        line[:stars] = line[:stars].to_i
        line[:actors] = line[:actors].split(',')
        line[:collection] = self
        Movie.create(line)
      end
    end

    def each(&_block)
      @films.each do |movie|
        yield(movie)
      end
    end

    def all
      @films
    end

    def sort_by(field)
      @films.sort_by(&field)
    end

    def filter(params, movies = @films)
      if params.is_a? Array
        params.map { |hash| apply_filter(hash, movies) }.flatten.uniq
      else
        apply_filter(params, movies)
      end
    end

    def stats(field)
      @films.map { |film| film.send(field) }
            .compact.sort.group_by(&:itself)
            .map { |key, value| [key, value.count] }
            .to_h
    end

    def genres
      @genres ||= @films.map(&:genre).flatten.uniq
    end

    def random_by_stars(films)
      films.sort { |film| film.stars * Random.rand }.last
    end

    private

    def apply_filter(params, movies)
      params.reduce(movies) do |films, (key, value)|
        films.select { |film| film.matches?(key, value) }
      end
    end
  end
end
