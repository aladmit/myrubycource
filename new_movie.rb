require './movie.rb'

class NewMovie < Movie
  def price
    5
  end

  def to_s
    "#{title} - новинка, вышло #{Time.new.year - year} лет назад!"
  end

  def period
    :new
  end
end
