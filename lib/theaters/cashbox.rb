require 'theaters/exeptions'
require 'money'

I18n.enforce_available_locales = false

module Theaters
  module Cashbox
    def refill(money)
      @cashbox = Money.new(cashbox.fractional + money, 'USD')
    end

    def money
      cashbox
    end

    def take(who)
      raise CallToPolice if who != 'Bank'

      @cashbox = Money.new(0, 'USD')
      'Проведена инкассация'
    end

    def cashbox(money = 0)
      @cashbox ||= Money.new(money, 'USD')
    end
  end
end
