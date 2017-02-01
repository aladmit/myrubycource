require 'spec_helper.rb'
require 'theaters/cashbox'
require 'money'

class Test
  include Theaters::Cashbox
end

RSpec.describe Theaters::Cashbox do
  subject(:test_class) { Test.new }

  it 'refill cashbox' do
    expect { test_class.refill(5) }.to change { test_class.money.fractional }.by(5)
  end

  it '#money return amount of money from cashbox' do
    expect(test_class.money.cents).to eq test_class.cashbox.cents
  end

  context '#take' do
    context 'When money are taken by bank' do
      it 'should be successfully taken' do
        test_class = Test.new
        test_class.cashbox(5)

        expect { test_class.take('Bank') }.to change { test_class.money.fractional }.by(-5)
      end

      it 'should be return the message' do
        expect(test_class.take('Bank')).to eq 'Проведена инкассация'
      end
    end

    context 'when money are thean not bank' do
      it 'it should call to police' do
        expect { test_class.take('somebody') }.to raise_error(CallToPolice)
      end
    end
  end
end
