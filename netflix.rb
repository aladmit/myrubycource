require './movies.rb'
require './cashbox.rb'
require './exeptions.rb'

module Theaters
  class Netflix < MovieCollection
    include Cashbox

    attr_accessor :film, :start_time, :money
    attr_reader :cashbox

    def initialize(file = 'movies.txt')
      super
      @money = 0
      @cashbox = create_cashbox(File.read('./cashbox_netflix.txt'))
    end

    def show(params = {})
      movie = random_by_stars(self.filter(params))
      raise NoMoney.new(movie.title, movie.price, money) if money < movie.price

      @money -= movie.price
      self.film = movie
      self.start_time = Time.now

      "Now showing: #{film.to_s}"
    end

    def how_much?(title)
      movie = filter(title: title).first
      if movie.nil?
        raise MovieNotFound(title)
      else
        movie.price
      end
    end

    def pay(amount)
      @money += amount
      refill(amount)
      update_cashbox
    end

    def cash
      @cashbox
    end


    def end_time
      start_time + film.duration * 60
    end

    private
    def update_cashbox
      File.open('./cashbox_netflix.txt', 'w') do |file|
        file.truncate(0)
        file.puts @cashbox.cents
      end
    end
  end
end
