require 'spec_helper.rb'
require_relative '../netflix.rb'

RSpec.describe Netflix do
  subject(:netflix) { Netflix.new('./spec/movies.txt') }

  describe '#show' do
    before(:each) do
      netflix.pay(10)
    end

    it 'show some film now' do
      expect(netflix.show()).to match(/Now showing:/)
    end

    it 'use filter' do
      expect(netflix.show({producer: 'Oliver Stone', period: :modern})).to eq "Now showing: #{netflix.filter(producer: 'Oliver Stone', period: :modern).first.to_s}"
    end

    context 'should pay for movie' do

      it 'exception if user don`t pay' do
        netflix.money = 0
        expect { netflix.show() }.to raise_error(NoMoney)
      end

      it 'ancient' do
        expect { netflix.show(period: :ancient) }.to change(netflix, :money).by(-1)
      end

      it 'classic' do
        expect { netflix.show(period: :classic) }.to change(netflix, :money).by(-1.5)
      end

      it 'modern' do
        expect { netflix.show(period: :modern) }.to change(netflix, :money).by(-3)
      end

      it 'new' do
        expect { netflix.show(period: :new) }.to change(netflix, :money).by(-5)
      end
    end
  end

  it '#how_much? should return movie price' do
    expect(netflix.how_much?('The Terminator')).to eq 3
  end

  describe '#pay' do
    it 'should increase money' do
      expect { netflix.pay(20) }.to change { netflix.money }.from(0).to(20)
    end

    it 'get money to cashbox' do
      expect(netflix).to receive(:refill).and_call_original
      netflix.pay(20)
    end
  end
end
