require './movies.rb'

class Theatre < MovieCollection
  attr_accessor :film, :start_time

  MORNING = 8..11
  MIDDLE = 12..16
  EVENING = 17..22

  FILTERS = { 8..11 => [{ period: :ancient }],
              12..16 => [{ genre: 'Comedy' }, { genre: 'Action' }],
              17..22 => [{ genre: 'Drama' }, { genre: 'Horror' }] }

  def show(time = nil)
    self.film = random_by_stars(filter_by_time(time))
    self.start_time = Time.now

    "Now showing: #{film.title} #{start_time} - #{end_time}"
  end

  def end_time
    start_time + film.duration * 60
  end

  def when?(title)
    movie = filter(title: title).first

    time =
      FILTERS.detect { |_time, filters| filters.map { |filter| filter.map { |key, value| movie.matches?(key, value) } }.flatten.include?(true) }.first

    "С #{time.first} до #{time.last}"
  end

  def filter_by_time(time)
    return all if time.nil?
    case DateTime.parse(time).hour
    when MORNING
      filter(FILTERS[MORNING])
    when MIDDLE
      filter(FILTERS[MIDDLE])
    when EVENING
      filter(FILTERS[MIDDLE])
    end
  end
end
