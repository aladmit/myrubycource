require './movies.rb'
require './exeptions.rb'

class Netflix < MovieCollection
  attr_accessor :film, :start_time, :money

  def initialize(file = 'movies.txt')
    super
    @money = 0
  end

  def show(params)
    movie = random_by_stars(self.filter(params))
    raise NoMoney if money < movie.class::PRICE

    @money -= movie.class::PRICE
    self.film = movie
    self.start_time = Time.now

    "Now showing: #{film.to_s}"
  end

  def how_much?(title)
    filter(title: title).first.class::PRICE
  end

  def pay(amount)
    @money += amount
  end

  def end_time
    start_time + film.duration * 60
  end
end
