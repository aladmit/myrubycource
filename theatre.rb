require './movies.rb'
require './cashbox.rb'
require './theatre_hall.rb'
require './theatre_period.rb'

module Theaters
  class Theatre < MovieCollection
    include Cashbox

    attr_accessor :film, :start_time
    attr_reader :halls, :periods

    MORNING = 8..11
    MIDDLE = 12..16
    EVENING = 17..22

    FILTERS = { 8..11 => [{ period: :ancient }],
                12..16 => [{ genre: 'Comedy' }, { genre: 'Action' }],
                17..22 => [{ genre: 'Drama' }, { genre: 'Horror' }] }.freeze

    PRICES = { 8..11 => 3,
               12..16 => 5,
               17..22 => 10 }.freeze

    def initialize(file = 'movies.txt', &block)
      super

      @halls ||= []
      @periods ||= []

      instance_eval(&block) if block_given?
    end

    def hall(color, title: nil, places: 0)
      @halls << Theaters::TheatreHall.new(color, title, places)
    end

    def period(time, &block)
      period = Theaters::TheatrePeriod.new(time, &block)
      raise InvalidPeriod if invalid_period?(period)

      @periods << period
    end

    def show(time = nil)
      if @periods.empty?
        self.film = random_by_stars(filter_by_time(time))
      else
        self.film = random_by_stars(filter_by_period(time))
      end

      self.start_time = Time.now
      "Now showing: #{film.title} #{start_time} - #{end_time}"
    end

    def end_time
      start_time + film.duration * 60
    end

    def when?(title)
      movie = filter(title: title).first or raise MovieNotFound.new(title)

      begin
        time = detect_filter(movie)
      rescue NoMethodError
        raise MovieTimeNotFound.new(movie.title)
      end

      "С #{time.first} до #{time.last}"
    end

    def filter_by_time(time = nil)
      return all if time.nil?
      time = DateTime.parse(time).hour

      [MORNING, MIDDLE, EVENING].each do |part_of_day|
        return filter(FILTERS[part_of_day]) if part_of_day.include?(time)
      end
    end

    def filter_by_period(time)
      period = @periods.select { |p| p.time.cover?(time) }.sample
      filter(period.filters)
    end

    def cash
      cashbox
    end

    def buy_ticket(time)
      time = DateTime.parse(time).hour or raise MovieTimeNotFound.new('')

      movie = random_by_stars(filter_by_time("#{time}:00"))

      PRICES.each do |part_of_day, price|
        if part_of_day.include?(time)
          refill(price)
          return "Вы купили билет на #{movie.title}"
        end
      end
    end

    private

    def detect_filter(movie)
      FILTERS.detect do |_time, filters|
        filters.map { |filter| check_matches(filter, movie) }
               .flatten.include?(true)
      end.first
    end

    def check_matches(filter, movie)
      filter.map { |key, value| movie.matches?(key, value) }
    end

    def invalid_period?(period)
      periods = period.hall.map { |color| @periods.select { |p| p.hall.include?(color) } }.flatten
      periods << period
      periods.combination(2).any? { |p1, p2| p1.intersects?(p2) }
    end
  end
end
