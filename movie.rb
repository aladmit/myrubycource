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

  def has_genre?(genre)
   if self.genre.include?(genre)
     true
    else
      if @collection.genres.include?(genre)
        false
      else
       raise GenreDoesNotExist
      end
   end
  end
end
