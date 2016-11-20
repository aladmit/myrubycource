require './exeptions.rb'
require 'money'

I18n.enforce_available_locales = false

module Theaters
  module Cashbox
    def create_cashbox(amount = 0)
      Money.new(amount, 'USD')
    end

    def refill(money)
      @cashbox += Money.new(money, 'USD')
    end

    def money
      @cashbox
    end

    def take(who)
      if who == 'Bank'
        @cashbox = Money.new(0, 'USD')
        'Проведена инкассация'
      else
        raise CallToPolice
      end
    end
  end
end
