class MovieByGenre
  def initialize(collection)
    genres = collection.genres.map(&:downcase)

    genres.each do |genre|
      self.class.send(:define_method, genre) do
        collection.filter(genre: genre)
      end
    end
  end
end
