require './movies.rb'

class Theatre < MovieCollection
  attr_accessor :film, :start_time

  def show(time = nil)
    self.film = filter_by_time(time).sample
    self.start_time = Time.now

    "Now showing: #{film.title} #{start_time} - #{end_time}"
  end

  def end_time
    start_time + film.duration * 60
  end

  def when?(title)
    movie = filter(title: title)[0]
    if movie.matches?(:period, :ancient)
      "С 8 до 11"
    elsif movie.matches?(:genre, 'Comedy') || movie.matches?(:genre, 'Action')
      "С 12 до 16"
    elsif movie.matches?(:genre, 'Drama') || movie.matches?(:genre, 'Horror')
      "C 17 до 22"
    end
  end

  def filter_by_time(time)
    return all if time.nil?
    case DateTime.parse(time).hour
    when 8..11
      filter(period: :ancient)
    when 12..16
      (filter(genre: 'Comedy') + filter(genre: 'Action')).uniq
    when 17..22
      (filter(genre: 'Drama') + filter(genre: 'Horror')).uniq
    end
  end
end
