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
    it 'how some film now' do
      expect(netflix.show({})).to match(/Now showing:/)
    end

    it 'return random film' do
      expect((1..10).collect { netflix.show({}) }.uniq.count).not_to eq 1
    end

    it 'use filter' do
      expect(netflix).to receive(:filter).with(producer: 'Oliver Stone', period: :modern).and_return([test_movie])
      expect(netflix.show({producer: 'Oliver Stone', period: :modern})).to eq "Now showing: #{test_movie.to_s}"
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
