#!/home/andrey/.rbenv/shims/ruby
def print_films(films)
  films.map do |film|
    puts "#{film[:title]}: #{film[:producer]} (#{film[:date]}; #{film[:genre].join("/")}) - #{film[:duration]} min"
  end
end

file = ARGV[0] || "movies.txt"

unless File.exist?(file)
  puts "File #{file} does not exist"
  exit
end

FIELDS = %i(url title year country date genre duration stars producer actors)

films = File.open(file, 'r').map do |line|
  film = FIELDS.zip(line.split('|')).to_h
  film[:duration] = film[:duration].split(' ')[0].to_i
  film[:genre] = film[:genre].split(',')
  film
end

puts "Long films:"
print_films(films.sort_by { |film| film[:duration] }.last(5))

puts "Camedy:"
print_films(films.sort_by{ |film| film[:genre].include?("Camedy") }.sort_by { |film| film[:date] }.first(10))

puts "Producers:"
producers = films.map { |film| film[:producer] }.sort_by { |man| man.split(' ')[-1] }.uniq
producers.map { |man| puts man }

puts films.count { |film| film[:country] != 'USA' }
