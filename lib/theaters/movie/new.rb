require 'theaters/movie'

module Theaters
  class Movie::New < Movie
    PRICE = 5

    def to_s
      "#{title} - новинка, вышло #{Time.new.year - year} лет назад!"
    end
  end
end
