require 'csv'
require './movie.rb'
require './ancient_movie.rb'
require './classic_movie.rb'
require './modern_movie.rb'
require './new_movie.rb'

class MovieCollection
  FIELDS = %i(url title year country date genre duration stars producer actors)

  def initialize(file = 'movies.txt')
    @films = CSV.read(file, col_sep: '|', headers: FIELDS).map do |line|
      add_movie(line.to_h)
    end
  end

  def all
    @films
  end

  def sort_by(field)
    @films.sort_by(&field)
  end

  def filter(params)
    params.reduce(@films) do |films, (key, value)|
      films.select { |film| film.matches?(key, value) }
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

  def add_movie(fields)
    case fields[:year].to_i
    when 1900..1945
      AncientMovie.new(fields, self)
    when 1946..1968
      ClassicMovie.new(fields, self)
    when 1969..2000
      ModernMovie.new(fields, self)
    when 2001..Time.new.year
      NewMovie.new(fields, self)
    end
  end
end
