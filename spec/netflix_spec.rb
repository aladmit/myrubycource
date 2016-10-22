require 'spec_helper.rb'
require_relative '../netflix.rb'

RSpec.describe Netflix do
  subject(:netflix) { Netflix.new('./spec/movies.txt') }
  let(:test_movie) { ModernMovie.new({url: "http://imdb.com/title/tt0091763/?ref_=chttp_tt_170",
                                      title: "Platoon",
                                      year: 1986,
                                      country: "UK",
                                      date: "1987-02-06",
                                      genre: "Drama,War",
                                      duration: 120,
                                      producer: "Oliver Stone",
                                      actors: "Charlie Sheen,Tom Berenger,Willem Dafoe"
                                     },netflix.all) }

  describe '#show' do
    it 'show some film now' do
      netflix.pay(10)
      expect(netflix.show({})).to match(/Now showing:/)
    end

    it 'return random film' do
      netflix.pay(100)
      expect((1..10).collect { netflix.show({}) }.uniq.count).not_to eq 1
    end

    it 'use filter' do
      netflix.pay(10)
      expect(netflix).to receive(:filter).with(producer: 'Oliver Stone', period: :modern).and_return([test_movie])
      expect(netflix.show({producer: 'Oliver Stone', period: :modern})).to eq "Now showing: #{test_movie.to_s}"
    end

    context 'should pay for movie' do
      it 'exception if user don`t pay' do
        netflix.money = 0
        expect { netflix.show({}) }.to raise_error(NoMoney)
      end

      it 'ancient' do
        netflix.pay(1)
        money = netflix.money
        netflix.show(period: :ancient)
        expect(netflix.money).to eq money - 1
      end

      it 'classic' do
        netflix.pay(1.5)
        money = netflix.money
        netflix.show(period: :classic)
        expect(netflix.money).to eq money - 1.5
      end

      it 'modern' do
        netflix.pay(3)
        money = netflix.money
        netflix.show(period: :modern)
        expect(netflix.money).to eq money - 3
      end

      it 'new' do
        netflix.pay(5)
        money = netflix.money
        netflix.show(period: :new)
        expect(netflix.money).to eq money - 5
      end
    end
  end

  it '#how_much? should return movie price' do
    expect(netflix.how_much?('The Terminator')).to eq 3
  end

  describe '#pay' do
    it 'should increase money' do
      expect(netflix.money).to eq 0
      netflix.pay(20)
      expect(netflix.money).to eq 20
    end
  end
end
