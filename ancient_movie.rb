require './movie.rb'

class AncientMovie < Movie
  PRICE = 1

  def to_s
    "#{title} - старый фильм (#{year} год)"
  end
end
