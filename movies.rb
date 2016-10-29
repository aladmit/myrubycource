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

  def random_by_stars(films)
    stars_sum = films.inject(0) { |sum, film| sum + film.stars }
    counter = 0
    random = Random.rand(1..stars_sum)

    film = films.each do |i|
      counter += i.stars
      break i if counter >= random
    end
    film
  end
end
