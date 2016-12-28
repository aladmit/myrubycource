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
      @user_nested_filters = {}
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
      user_filters = params.select { |key, _value| @user_filters.keys.include?(key) }
      user_nested_filters = params.select { |key, _value| @user_nested_filters.keys.include?(key) }
      system_filters = (params.to_a - user_filters.to_a - user_nested_filters.to_a).to_h


      movies = apply_user_filters(user_filters)
      movies = apply_nested_filters(user_nested_filters, movies)
      filter(system_filters, movies)
    end

    def apply_user_filters(user_filters)
      user_filters.reduce(@films) do |films, (key, value)|
        films.select { |film| @user_filters[key].call film, value }
      end
    end

    def create_nested_filter(key, from, arg)
      @user_nested_filters[key] = { from: from, arg: arg }
    end

    def apply_nested_filters(filters, all_movies)
      filters.reduce(all_movies) do |movies, (key, value)|
        filter = @user_nested_filters[key]
        movies.select { |movie| @user_filters[filter[:from]].call movie, filter[:arg] }
      end
    end
  end
end
