require './movie.rb'

class NewMovie < Movie
  def to_s
    "#{title} - новинка, вышло #{Time.new.year - year} лет назад!"
  end
end
