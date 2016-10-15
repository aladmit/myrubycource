require './movie.rb'

class AncientMovie < Movie
  def price
    1
  end

  def to_s
    "#{title} - старый фильм (#{year} год)"
  end

  def period
    :ancient
  end
end
