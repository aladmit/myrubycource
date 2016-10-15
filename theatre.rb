require './movies.rb'

class Theatre < MovieCollection
  attr_accessor :film, :start_time

  def show
    self.film = all.sample
    self.start_time = Time.now

    "Now showing: #{film.title} #{start_time} - #{end_time}"
  end

  def end_time
    start_time + film.duration * 60
  end
end
