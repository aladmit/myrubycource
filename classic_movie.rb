require './movie.rb'

class ClassicMovie < Movie
  PRICE = 1.5

  def to_s
    "#{title} - классический фильм, режиссер #{producer}(еще #{producer_movies_count} его фильмов в списке)"
  end

  def producer_movies_count
    movies = @collection.filter(producer: producer).count - 1
  end
end
