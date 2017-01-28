require 'virtus'
require 'theaters/virtus_attributes'

module Theaters
  class Movie
    include Virtus.model

    values do
      attribute :url, String
      attribute :title, String
      attribute :year, Fixnum, strict: true
      attribute :country, String
      attribute :date, Date
      attribute :genre, StrArray
      attribute :duration, Duration, strict: true
      attribute :stars, Fixnum, strict: true
      attribute :producer, String
      attribute :actors, StrArray
      attribute :collection
    end

    def month
      date.month
    end

    def price
      self.class::PRICE
    end

    def period
      self.class.to_s.match(/(?<=Theaters::Movie::).*/).to_s.downcase.to_sym
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
        Movie::Ancient
      when 1946..1968
        Movie::Classic
      when 1969..2000
        Movie::Modern
      when 2001..Time.new.year
        Movie::New
      end.new(fields)
    end

    def to_s
      "#{title}: #{producer} (#{date}; #{genre.join('/')}) - #{duration} min"
    end

    def genre?(name)
      raise GenreDoesNotExist unless @collection.genres.include?(name)
      genre.include?(name)
    end
  end
end
