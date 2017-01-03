module Theaters
  class TheatrePeriod
    attr_reader :time, :description, :filters, :price, :hall

    def initialize(time)
      @time = time
    end

    def self.description(text)
      @description = text
    end

    def self.filters(hash)
      @filters = hash
    end

    def self.price(price)
      @price = price
    end

    def self.hall(*args)
      @args = args
    end
  end
end
