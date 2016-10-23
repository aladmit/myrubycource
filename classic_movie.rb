require './movie.rb'

class ClassicMovie < Movie
  def price
    1.5
  end

  def to_s
    "#{title} - классический фильм, режиссер #{producer}(еще #{producer_movies.count} его фильмов в списке)"
  end

  def period
    :classic
  end

  def producer_movies
    movies = @collection.filter(producer: producer)
    movies.delete(self)
    movies
  end
end
