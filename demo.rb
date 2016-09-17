#!/home/andrey/.rbenv/shims/ruby
require './movies.rb'
require 'pry'
require './exeptions.rb'

def print_films(films)
  films.map do |film|
    puts "#{film.title}: #{film.producer} (#{film.date}; #{film.genre.join('/')}) - #{film.duration} min"
  end
end

file = ARGV[0] || "movies.txt"

unless File.exist?(file)
  puts "File #{file} does not exist"
  exit
end

films = MovieCollection.new(file)
puts "Long films:"
print_films(films.sort_by(:duration).last(5))
puts "Comedy:"
print_films(films.filter(genre: 'Comedy').sort_by(&:date).first(10))

puts "Producers:"
producers = films.all.map(&:producer).sort_by { |man| man.split(' ').last }.uniq
producers.map { |man| puts man }

puts films.all.count { |film| film.country != 'USA' }
puts "Statistics"
films.stats(:month).each do |key, value|
  puts "#{key}: #{value}"
end

begin
  puts films.all[0].has_genre?('bla')
rescue GenreDoesNotExist
  puts "Film does not have a genre"
end
