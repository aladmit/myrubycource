class MovieByCountry
  def initialize(collection)
    @collection = collection
  end

  def method_missing(name, *args, &block)
    @collection.filter(country: name.downcase)
  end
end
