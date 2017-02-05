require 'thor'
require 'theaters'

module Theaters
  class CLI < Thor
    package_name "Theaters"

    desc "netflix", "interface for netflix"
    method_option :pay, type: :numeric, required: true
    method_option :filters, type: :string

    def netflix
      theatre = Netflix.new
      theatre.pay(options[:pay])

      filters = eval(options[:filters]) || {}

      puts theatre.show(filters)
    end

    desc "theatre", "interface for theatre"
    method_option :time, type: :string

    def theatre
      theatre = Theatre.new
      puts theatre.show(options[:time])
    end
  end
end
