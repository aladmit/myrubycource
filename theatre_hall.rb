module Theaters
  class TheatreHall
    attr_reader :color, :title, :places

    def initialize(color, title, places)
      @color = color
      @title = title
      @places = places
    end
  end
end
