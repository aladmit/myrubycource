class MovieByCountry
  def initialize(collection)
    @collection = collection
  end

  def method_missing(name, *args)
    raise ArgumentError unless args.empty?
    @collection.filter(country: name.downcase)
  end
end
