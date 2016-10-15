require './movies.rb'

class Netflix < MovieCollection
  attr_accessor :film, :start_time

  def show(filter)
    self.film = self.filter(filter).sample
    self.start_time = Time.now

    "Now showing: #{film.to_s}"
  end

  def how_much?(title)
    filter(title: title).first.price
  end

  def end_time
    start_time + film.duration * 60
  end
end
