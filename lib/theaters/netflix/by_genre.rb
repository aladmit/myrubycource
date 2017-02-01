module Theaters
  class Netflix::ByGenre
    def initialize(collection)
      genres = collection.genres.map(&:downcase)

      genres.each do |genre|
        define_singleton_method(genre) do
          collection.filter(genre: genre)
        end
      end
    end
  end
end
