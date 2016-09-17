class Movie
  attr_accessor :url, :title, :year, :country, :date, :genre, :duration, :stars, :producer, :actors

  def initialize(params)
    @url = params[:url]
    @title = params[:title]
    @year = params[:year]
    @country = params[:country]
    @date = params[:date].split('-')
    @genre = params[:genre].split(',')
    @duration = params[:stars].split(' ')[0].to_i
    @producer = params[:producer]
    @actors = params[:actors].split(',')
  end

  def has_genre?(genre)
    self.genre.include?(genre)
  end
end
