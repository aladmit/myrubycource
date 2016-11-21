require 'spec_helper.rb'
require './cashbox.rb'
require 'money'

class Test
  include Theaters::Cashbox
end

RSpec.describe Theaters::Cashbox do
  subject(:test_class) { Test.new }

  it 'refill cashbox' do
    expect { test_class.refill(5) }.to change{ test_class.money.fractional }.from(0).to(5)
  end

  it '#money return amount of money from cashbox' do
    expect(test_class.money.cents).to eq test_class.cashbox.cents
  end

  context '#take' do
    context 'Bank can take the money' do
      it 'money should be eq to zero' do
        test_class = Test.new
        test_class.cashbox(5)

        expect { test_class.take('Bank') }.to change { test_class.money.fractional }.from(5).to(0)
      end

      it 'and return the message' do
        expect(test_class.take('Bank')).to eq 'Проведена инкассация'
      end
    end

    context 'only bank can take the money' do
      it 'return exception' do
        expect { test_class.take('somebody') }.to raise_error(CallToPolice)
      end
    end
  end
end
