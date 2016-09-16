#!/home/andrey/.rbenv/shims/ruby
def print_films(films)
  films.map do |film|
    puts "#{film[:title]}: #{film[:producer]} (#{film[:date]}; #{film[:genre].join("/").to_s}) - #{film[:duration]} min"
  end
end

file = ARGV[0] || "movies.txt"

unless File.exist?(file)
  puts "File #{file} does not exist"
  exit
end

films = []

FIELDS = %i(url title year country date genre duration stars producer actors)

File.open(file,'r').map do |line|
  film = FIELDS.zip(line.split('|')).to_h
  film[:duration] = film[:duration].split(' ')[0].to_i
  film[:genre] = film[:genre].split(',')
  films.push film
end

puts "Long films:"
films.sort_by! { |film| film[:duration] }
print_films(films.reverse[0..4])

puts "Camedy"
films.sort_by! { |film| film[:date] }
print_films(films[0..9])

puts "Producers"
producers = []
films.map { |film| producers.push film[:producer] }
producers.sort_by { |man| man.split(' ')[-1] }.uniq.map { |man| puts man }

puts films.count { |film| film[:country] != 'USA' }
