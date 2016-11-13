module Helpers
  def movies_at(hours)
    hours.map { |hour| theatre.filter_by_time("#{hour}:00") }.flatten
  end
end
