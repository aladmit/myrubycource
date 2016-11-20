require 'csv'
require './movie.rb'
require './ancient_movie.rb'
require './classic_movie.rb'
require './modern_movie.rb'
require './new_movie.rb'

module Theaters
  class MovieCollection
    include Enumerable

    FIELDS = %i(url title year country date genre duration stars producer actors)

    def initialize(file = 'movies.txt')
      @films = CSV.read(file, col_sep: '|', headers: FIELDS).map do |line|
        Movie.create(line.to_h, self)
      end
    end

    def all
      @films
    end

    def sort_by(field)
      @films.sort_by(&field)
    end

    def filter(params)
      if params.is_a? Array
        params.map { |hash| apply_filter(hash) }.flatten.uniq
      else
        apply_filter(params)
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
    def apply_filter(params)
      params.reduce(@films) do |films, (key, value)|
        films.select { |film| film.matches?(key, value) }
      end
    end
  end
end
