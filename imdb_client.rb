require 'nokogiri'
require 'open-uri'
require 'ruby-progressbar'

class IMDBClient
  def movies_list
    list ||= parse_movies_list
  end

  def movies_budgets
    progressbar = ProgressBar.create(title: 'Prase movies', total: movies_list.count)

    budgets = movies_list.map do |movie|
      progressbar.increment
      { title: movie[:title], budget: parse_movie_budget(movie[:link]) }
    end

    File.open('./budgets.yml', 'w') { |f| f.write(budgets.to_yaml) }
  end

  private

  def parse_movie_budget(link)
    page = Nokogiri::HTML(open(link))
    page.css('#main_bottom #titleDetails').first
        .css('.txt-block')[6].children[2].text
        .gsub("\n", '').gsub(' ', '')
  end

  def parse_movies_list
    page = Nokogiri::HTML(open('http://www.imdb.com/chart/top'))

    movies = page.css('.lister .chart tbody tr')

    movies.map { |movie| parse_rated_movie(movie) }
  end

  def parse_rated_movie(movie)
    element = movie.css('.titleColumn > a').first

    { id: parse_id(element['href']),
      title: element.text,
      link: 'http://imdb.com' + element['href'] }
  end

  def parse_id(href)
    href.scan(/[a-z]{2}\d{6}/).first
  end
end
