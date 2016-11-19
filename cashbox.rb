require './exeptions.rb'

module Cashbox
  def refill(money)
    @money += money
  end

  def money
    @money
  end

  def take(who)
    if who == 'Bank'
      @money = 0
      'Проведена инкассация'
    else
      raise CallToPolice
    end
  end
end
