require 'nokogiri'
require 'open-uri'
require 'ruby-progressbar'
require 'themoviedb'

class IMDBClient
  Tmdb::Api.key('66dd6d4dec26548c02b70560ec20020f')

  def movies_list
    @list ||= parse_movies_list
  end

  def movies_budgets
    progressbar = ProgressBar.create(title: 'Get budgets', total: movies_list.count)

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

    progress = ProgressBar.create(title: 'Parse movies', total: movies.count)

    movies.map do |movie|
      progress.increment
      parse_rated_movie(movie)
    end
  end

  def parse_rated_movie(movie)
    element = movie.css('.titleColumn > a').first
    id = parse_id(element['href'])

    { id: id,
      title: element.text,
      link: 'http://imdb.com' + element['href'],
      titles: titles(id),
      poster: poster_url(id) }
  end

  def parse_id(href)
    href.scan(/(?<=\/title\/).*(?=\/)/).first
  end

  def titles(id)
    Tmdb::Movie.alternative_titles(id)['titles'].map do |title|
      [ title['iso_3166_1'].to_s, title['title'] ]
    end.to_h
  end

  def poster_url(id)
    base_url = Tmdb::Configuration.new.base_url
    poster = Tmdb::Movie.detail(id)['poster_path']

    base_url + 'original' + poster
  end
end
