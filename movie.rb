class Movie
  attr_accessor :url, :title, :year, :country, :date, :genre, :duration, :stars, :producer, :actors

  def initialize(params, collection)
    @url = params[:url]
    @title = params[:title]
    @year = params[:year].to_i
    @country = params[:country]
    @date = params[:date].split('-')
    @genre = params[:genre].split(',')
    @duration = params[:duration].to_i
    @stars = params[:stars].to_i
    @producer = params[:producer]
    @actors = params[:actors].split(',')
    @collection = collection
  end

  def month
    date[1]
  end

  def period
    self.class.to_s.match(/.*(?=Movie)/).to_s.downcase.to_sym
  end

  def price
    self.class::PRICE
  end

  def self.create(fields, collection)
    case fields[:year].to_i
    when 1900..1945
      AncientMovie.new(fields, collection)
    when 1946..1968
      ClassicMovie.new(fields, collection)
    when 1969..2000
      ModernMovie.new(fields, collection)
    when 2001..Time.new.year
      NewMovie.new(fields, collection)
    end
  end

  def has_genre?(name)
    raise GenreDoesNotExist unless @collection.genres.include?(name)
    genre.include?(name)
  end

  def matches?(filter, value)
    if send(filter).is_a? Array
      send(filter).any? { |v| value === v }
    else
      value === send(filter)
    end
  end

  def to_s
    "#{title}: #{producer} (#{date}; #{genre.join('/')}) - #{duration} min"
  end

  def inspect
    "#<Movie(title=#{title}, producer=#{producer}, date=#{date}, genres=#{genre.join('/')} duration=#{duration}, actors=#{actors})>"
  end
end
