class Movie
  attr_accessor :url, :title, :year, :country, :date, :genre, :duration, :stars, :producer, :actors

  def initialize(params, collection)
    @url = params[:url]
    @title = params[:title]
    @year = params[:year]
    @country = params[:country]
    @date = params[:date].split('-')
    @genre = params[:genre].split(',')
    @duration = params[:stars].split(' ')[0].to_i
    @producer = params[:producer]
    @actors = params[:actors].split(',')
    @collection = collection
  end

  def has_genre?(name)
    raise GenreDoesNotExist unless @collection.genres.include?(name)
    genre.include?(name)
  end

  def matches?(filter, value)
    if filter == :year
      return (value) === send(filter).to_i
    end
    if send(filter).class == Array
      send(filter).any? { |v| Regexp.new(value) === v }
    else
      Regexp.new(value) === send(filter)
    end
  end

  def to_s
    "#{title}: #{producer} (#{date}; #{genre.join('/')}) - #{duration} min"
  end

  def inspect
    "#<Movie(title=#{title}, producer=#{producer}, date=#{date}, genres=#{genre.join('/')} duration=#{duration}, actors=#{actors})>"
  end
end
