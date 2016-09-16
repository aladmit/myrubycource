#!/home/andrey/.rbenv/shims/ruby

file = ARGV[0].nil? ? "movies.txt" : ARGV[0]

unless File.exist?(file)
  puts "File #{file} does not exist"
  exit
end

films = []

File.open(file,'r').each_line do |line|
  string = line.split('|')
  film = {
    url: string[0],
    title: string[1],
    year: string[2],
    country: string[3],
    date: string[4],
    genre: string[5],
    duration: string[6],
    stars: string[7],
    producer: string[8],
    actors: string[9]
  }
  films.push film
end

films.each do |film|
  if film[:title].include?("Time")
    message = "title: #{film[:title]} starts: #{"*" * film[:stars].to_i}"
    puts message
  end
end
