require './movies.rb'
require './cashbox.rb'
require './exeptions.rb'

module Theaters
  class Netflix < MovieCollection
    extend Cashbox

    attr_accessor :film, :start_time, :money

    def initialize(file = 'movies.txt')
      super
      @money = 0
    end

    def show(params = {})
      movie = random_by_stars(filter(params))
      raise NoMoney.new(movie.title, movie.price, money) if money < movie.price

      @money -= movie.price
      self.film = movie
      self.start_time = Time.now

      "Now showing: #{film}"
    end

    def how_much?(title)
      movie = filter(title: title).first
      raise MovieNotFound(title) if movie.nil?

      movie.price
    end

    def pay(amount)
      @money += amount
      self.class.refill(amount)
    end

    def cash
      self.class.cashbox
    end

    private

    def end_time
      start_time + film.duration * 60
    end
  end
end
