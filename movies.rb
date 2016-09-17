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
    @films.sort_by { |film| film.send(field) }
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
    when :producer
      @films.group_by { |film| film.send(field) }.each do |key,value|
        stats[key] = value.count
      end
    when :actor
      @films.map(&:actors).flatten.sort.group_by(&:itself).each do |key, value|
        stats[key] = value.count
      end
    when :year
      @films.map(&:year).flatten.sort.group_by(&:itself).each do |key, value|
        stats[key] = value.count
      end
    when :month
      @films.reject { |film| film.date[1].nil? }.map { |film| film.date[1] }
        .sort.group_by(&:itself).each do |key, value|
          stats[key] = value.count
      end
    when :country
      @films.map(&:country).group_by(&:itself).each do |key, value|
        stats[key] = value.count
      end
    when :genre
      @films.map(&:genre).flatten.sort.group_by(&:itself).each do |key, value|
        stats[key] = value.count
      end
    end
    stats
  end
end
