require 'theaters/movie'

module Theaters
  class Movie::Ancient < Movie
    PRICE = 1

    def to_s
      "#{title} - старый фильм (#{year} год)"
    end
  end
end
