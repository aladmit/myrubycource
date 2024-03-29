require 'theaters/movie'

module Theaters
  class Movie::Classic < Movie
    PRICE = 1.5

    def to_s
      "#{title} - классический фильм, режиссер #{producer}(еще #{producer_movies_count} его фильмов в списке)"
    end

    private

    def producer_movies_count
      @collection.filter(producer: producer).count - 1
    end
  end
end
