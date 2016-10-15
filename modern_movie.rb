require './movie.rb'

class ModernMovie < Movie
  def price
    3
  end

  def to_s
    "#{title} - современное кино, играют: #{actors.join(', ')}"
  end

  def period
    :modern
  end
end
