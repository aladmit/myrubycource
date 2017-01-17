require 'nokogiri'
require 'open-uri'
require 'ruby-progressbar'
require 'themoviedb'
require 'erb'

class MDBClient
  Tmdb::Api.key(YAML::load(File.read('config.yml'))['key'])

  def movies_list
    @movies_list ||= parse_movies_list
  end

  def movies_budgets
    budgets = movies_list.map do |movie|
      { title: movie[:title], budget: movie[:budget] }
    end

    File.write('./budgets.yml', budgets.to_yaml)
  end

  def save_page
    template = ERB.new(File.read('result_template.html.erb'))
    File.write('./results.html', template.result(binding()))
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
    link = 'http://imdb.com' + element['href']

    { id: id,
      title: element.text,
      link: link,
      titles: titles(id),
      poster: poster_url(id),
      budget: parse_movie_budget(link) }
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
