require 'csv'
require './movie.rb'

class MovieCollection
  FIELDS = %i(url title year country date genre duration stars producer actors)

  def initialize(file)
    @films = CSV.read(file, col_sep: '|', headers: FIELDS).map do |line|
      Movie.new(line.to_h)
    end
  end

  def all
    @films
  end

  def sort_by(field)
    @films.sort_by(&field)
  end

  def filter(params)
    films = @films
    params.map do |key, value|
      films = films.select { |film| film.send(key).include?(value) }
    end.flatten
  end

  def stats(field)
    stats = {}

    case field
    when :month
      @films.reject { |film| film.date[1].nil? }.map { |film| film.date[1] }
        .sort.group_by(&:itself).each do |key, value|
          stats[key] = value.count
      end
    else
      @films.map(&:field).flatten.sort.group_by(&:itself).each do |key, value|
        stats[key] = value.count
      end
    end
    stats
  end
end
