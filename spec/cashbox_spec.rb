require 'spec_helper.rb'
require './cashbox.rb'
require 'money'

include Theaters::Cashbox

RSpec.describe Theaters::Cashbox do
  it 'create cashbox for dollars' do
    expect(create_cashbox(5)).to eq Money.new(5, 'USD')
  end

  it 'refill cashbox' do
    @cashbox = create_cashbox(0)
    expect { refill(5) }.to change{@cashbox.cents}.from(0).to(5)
  end

  it '#money return amount of money from cashbox' do
    @cashbox = create_cashbox(5)
    expect(money).to eq @cashbox
  end

  context '#take' do
    context 'Bank can take the money' do
      it 'money should be eq to zero' do
        @cashbox = create_cashbox(5)
        expect { take('Bank') }.to change { @cashbox.cents }.from(5).to(0)
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
