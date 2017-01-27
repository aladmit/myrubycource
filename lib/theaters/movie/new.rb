require 'theaters/movie'

module Theaters
  class NewMovie < Movie
    PRICE = 5

    def to_s
      "#{title} - новинка, вышло #{Time.new.year - year} лет назад!"
    end
  end
end
