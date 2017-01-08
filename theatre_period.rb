module Theaters
  class TheatrePeriod
    attr_reader :time, :description, :filters, :price, :hall

    def initialize(time, &block)
      @time = time
      self.class.class_eval &block

      self.class.instance_variables.each do |var|
        instance_variable_set(var, self.class.instance_variable_get(var))
      end
    end

    def self.description(description)
      @description = description
    end

    def self.filters(hash)
      @filters = hash
    end

    def self.price(price)
      @price = price
    end

    def self.hall(*halls)
      @hall = halls
    end

    def intersects?(period2)
      if hall.any? { |color| period2.hall.include?(color) }
        time2 = period2.time

        (time.cover?(time2.begin) && time.end != time2.end) || (time.cover?(time2.end) && time.end != time2.begin)
      end
    end
  end
end
