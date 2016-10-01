require 'csv'
require './movie.rb'

class MovieCollection
  FIELDS = %i(url title year country date genre duration stars producer actors)

  def initialize(file)
    @films = CSV.read(file, col_sep: '|', headers: FIELDS).map do |line|
      Movie.new(line.to_h, self)
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
    @films.map(&:genre).flatten.uniq
  end
end
