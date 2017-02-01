require 'nokogiri'
require 'open-uri'
require 'ruby-progressbar'
require 'themoviedb'
require 'erb'

module Theaters
  class InfoLoader
    Tmdb::Api.key(YAML::load(File.read('config.yml'))['key'])

    attr_reader :movies_list

    def load_list!(progress: true)
      page = Nokogiri::HTML(open('http://www.imdb.com/chart/top'))
      movies = page.css('.lister .chart tbody tr')

      bar = ProgressBar.create(title: 'Load', total: movies.count) if progress

      @movies_list =
        movies.map do |movie|
          bar.increment if progress

          parse_rated_movie(movie)
        end
    end

    def load_budgets(cache: false)
      if cache
        budgets = load_cache(cache)
        save_budgets(budgets, cache)
      else
        budgets = parse_budgets
      end

      budgets
    end

    def load_cache(file)
      cache = YAML::load(File.read(file))
      cache.empty? ? parse_budgets : cache
    rescue
      parse_budgets
    end

    def save_budgets(budgets, file)
      File.write(file, budgets.to_yaml)
    end

    def parse_budgets
      @movies_list.map do |movie|
        { title: movie[:title], budget: parse_budget(movie[:link]), id: movie[:id] }
      end
    end

    def save_page(cache: false, file: 'results.html')
      template = ERB.new(File.read('result_template.html.erb'))
      budgets = load_budgets(cache: cache)
      movies = @movies_list.map do |movie|
        budget = budgets.select { |b| b[:id] == movie[:id] }.first
        budget = { budget: nil } if budget.nil?
        movie.merge!(budget: budget[:budget])
      end

      File.write(file, template.result(binding()))
    end

    def parse_budget(link)
      page = Nokogiri::HTML(open(link))
      page.css('#main_bottom #titleDetails').first
          .css('.txt-block')[6].children[2].text
          .gsub("\n", '').gsub(' ', '')
    end

    private

    def parse_rated_movie(movie)
      element = movie.css('.titleColumn > a').first
      id = parse_id(element['href'])
      link = 'http://imdb.com' + element['href']

      { id: id,
        title: element.text,
        link: link,
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
end
