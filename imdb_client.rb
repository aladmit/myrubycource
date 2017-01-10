require 'nokogiri'
require 'open-uri'

class IMDBClient
  def movies_list
    list ||= get_movies_list
  end

  private

  def get_movies_list
    page =  Nokogiri::HTML(open('http://www.imdb.com/chart/top'))

    movies = page.css('.lister .chart tbody tr')

    movies.map { |movie| parse_rated_movie(movie) }
  end

  def parse_rated_movie(movie)
    element = movie.css('.titleColumn > a').first

    { title: element.text, link: 'http://imdb.com' + element['href'] }
  end
end
