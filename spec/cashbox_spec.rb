require 'spec_helper.rb'
require './cashbox.rb'

include Cashbox

RSpec.describe Cashbox do
  it 'refill cashbox' do
    @money = 0
    expect { refill(5) }.to change{@money}.from(0).to(5)
  end

  it '#money return amount of money from cashbox' do
    @money = 5
    expect(money).to eq 5
  end

  context '#take' do
    context 'Bank can take the money' do
      it 'money should be eq to zero' do
        @money = 5
        expect { take('Bank') }.to change { @money }.from(5).to(0)
      end

      it 'and return the message' do
        expect(take('Bank')).to eq 'Проведена инкассация'
      end
    end

    context 'only bank can take the money' do
      it 'return exception' do
        expect { take('somebody') }.to raise_error(CallToPolice)
      end
    end
  end
end
