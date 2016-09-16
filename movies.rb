#!/home/andrey/.rbenv/shims/ruby
good = ["The Matrix", "Leon"]

if good.include?(ARGV[0])
  puts "#{ARGV[0]} is a good movie"
  exit
end

if ARGV[0] == "Titanic"
  puts "Titanic is a bad movide"
  exit
end

puts "Havent't seen #{ARGV[0]} yet"
