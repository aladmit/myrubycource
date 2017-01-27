module Theaters
  class Theatre
    class Period
      attr_reader :time, :description, :filters, :price, :hall

      def initialize(time, &block)
        @time = time
        instance_eval &block
     end

      def description(description = nil)
        return @description unless description
        @description = description
      end

      def filters(hash = nil)
        return @filters unless hash
        @filters = hash
      end

      def price(price = nil)
        return @price unless price
        @price = price
      end

      def hall(*halls)
        return @hall if halls.empty?
        @hall = halls
      end

      def intersects?(period2)
        hall_intersected?(period2) && time_intersected?(period2)
      end

      private

      def hall_intersected?(period2)
        hall.any? { |color| period2.hall.include?(color) }
      end

      def time_intersected?(period2)
        time2 = period2.time
        (time.cover?(time2.begin) && time.end != time2.end) || (time.cover?(time2.end) && time.end != time2.begin)
      end
    end
  end
end
