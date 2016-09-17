#!/home/andrey/.rbenv/shims/ruby
require 'csv'
require 'ostruct'

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

FIELDS = %i(url title year country date genre duration stars producer actors)

films = CSV.read(file, {col_sep: '|'}).map do |line|
  film = OpenStruct.new(FIELDS.zip(line).to_h)
  film.duration = film.duration.split(' ')[0].to_i
  film.genre = film.genre.split(',')
  film
end

puts "Long films:"
print_films(films.sort_by { |film| film.duration }.last(5))

puts "Comedy:"
print_films(films.select { |film| film.genre.include?("Comedy") }.sort_by { |film| film.date }.first(10))

puts "Producers:"
producers = films.map { |film| film.producer }.sort_by { |man| man.split(' ').last }.uniq
producers.map { |man| puts man }

puts films.count { |film| film.country != 'USA' }
