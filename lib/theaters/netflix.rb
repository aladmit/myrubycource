require 'theaters/movies'
require 'theaters/cashbox'
require 'theaters/exeptions'

module Theaters
  class Netflix < MovieCollection
    extend Cashbox

    attr_accessor :film, :start_time, :money

    def initialize(file = 'movies.txt')
      super
      @money = 0
      @user_filters = {}
    end

    def by_genre
      Theaters::Netflix::ByGenre.new(self)
    end

    def by_country
      Theaters::Netflix::ByCountry.new(self)
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

    def define_filter(key, from: nil, arg: nil, &block)
      if from.nil?
        @user_filters[key] = block
      else
        create_nested_filter(key, from, arg)
      end
    end

    private

    def end_time
      start_time + film.duration * 60
    end

    def apply_filters(params)
      user_filters, standart_filters = params.partition do |key, _value|
        @user_filters.keys.include?(key)
      end

      movies = apply_user_filters(user_filters.to_h)
      filter(standart_filters.to_h, movies)
    end

    def apply_user_filters(user_filters)
      user_filters.reduce(@films) do |films, (key, value)|
        films.select { |film| @user_filters[key].call film, value }
      end
    end

    def create_nested_filter(key, from, arg)
      @user_filters[key] = Proc.new { |film| @user_filters[from].call film, arg }
    end
  end
end

require 'theaters/netflix/by_genre'
require 'theaters/netflix/by_country'
