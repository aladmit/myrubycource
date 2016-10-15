require './movie.rb'

class ClassicMovie < Movie
  def price
    1.5
  end

  def to_s
    str = "#{title} - классический фильм, режиссер #{producer}\n"
    str += "Other films of producer:\n"
    producer_movies.each do |movie|
      str += "  #{movie.title}\n"
    end
    str
  end

  def producer_movies
    movies = @collection.filter(producer: producer)
    movies.delete(self)
    movies
  end
end
