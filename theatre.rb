require './movies.rb'

class Theatre < MovieCollection
  attr_accessor :film, :start_time

  MORNING = 8..11
  MIDDLE = 12..16
  EVENING = 17..22

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
      "С #{MORNING.first} до #{MORNING.last}"
    elsif movie.matches?(:genre, 'Comedy') || movie.matches?(:genre, 'Action')
      "С #{MIDDLE.first} до #{MIDDLE.last}"
    elsif movie.matches?(:genre, 'Drama') || movie.matches?(:genre, 'Horror')
      "C #{EVENING.first} до #{EVENING.last}"
    end
  end

  def filter_by_time(time)
    return all if time.nil?
    case DateTime.parse(time).hour
    when MORNING
      filter(period: :ancient)
    when MIDDLE
      (filter(genre: 'Comedy') + filter(genre: 'Action')).uniq
    when EVENING
      (filter(genre: 'Drama') + filter(genre: 'Horror')).uniq
    end
  end
end
