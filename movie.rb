require 'virtus'

module Theaters
  class Movie
    include Virtus.model

    values do
      attribute :url, String
      attribute :title, String
      attribute :year, Fixnum
      attribute :country, String
      attribute :date, Array
      attribute :genre, Array
      attribute :duration, Fixnum
      attribute :stars, Fixnum
      attribute :producer, String
      attribute :actors, Array
      attribute :month, String
      attribute :period, Symbol, default: :default_period
      attribute :price, Float, default: :default_price
      attribute :collection
    end

    def matches?(filter, value)
      if send(filter).is_a? Array
        send(filter).any? { |v| value === v }
      else
        value === send(filter)
      end
    end

    def self.create(fields)
      case fields[:year].to_i
      when 1900..1945
        AncientMovie
      when 1946..1968
        ClassicMovie
      when 1969..2000
        ModernMovie
      when 2001..Time.new.year
        NewMovie
      end.new(fields)
    end

    def to_s
      "#{title}: #{producer} (#{date}; #{genre.join('/')}) - #{duration} min"
    end

    def genre?(name)
      raise GenreDoesNotExist unless @collection.genres.include?(name)
      genre.include?(name)
    end

    private

    def default_period
      self.class.to_s.match(/(?<=Theaters::).*(?=Movie)/).to_s.downcase.to_sym
    end

    def default_price
      self.class::PRICE
    end
  end
end
