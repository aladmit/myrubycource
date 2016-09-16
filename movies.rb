#!/home/andrey/.rbenv/shims/ruby

file = ARGV[0] || "movies.txt"

unless File.exist?(file)
  puts "File #{file} does not exist"
  exit
end

FIELDS = %w(url title year country date genre duration stars produces actors)

File.open(file,'r').map do |line|
  film = FIELDS.zip(line.split('|')).to_h

  if film['title'].include?("Time")
    puts "title: #{film['title']} starts: #{"*" * film['stars'].to_i}"
  end
end
