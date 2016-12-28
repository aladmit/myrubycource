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
      @user_filters = {}
    end

    def show(params = {})
      movie =
        if block_given?
          @films.select { |film| yield film }.sample
        else
          random_by_stars(apply_filters(params))
        end
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

    def define_filter(key, &block)
      @user_filters[key] = block
    end

    private

    def end_time
      start_time + film.duration * 60
    end

    def apply_filters(params)
      filters = params.partition do |key, value|
        @user_filters.keys.include?(key) && value
      end

      movies = apply_user_filters(filters.first.to_h)
      filter(filters[1].to_h, movies)
    end

    def apply_user_filters(user_filters)
      user_filters.reduce(@films) do |films, (key, _value)|
        films.select { |film| @user_filters[key].call film }
      end
    end
  end
end
