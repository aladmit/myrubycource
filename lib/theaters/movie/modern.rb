require 'theaters/movie'

module Theaters
  class ModernMovie < Movie
    PRICE = 3

    def to_s
      "#{title} - современное кино, играют: #{actors.join(', ')}"
    end
  end
end
