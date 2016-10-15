require 'spec_helper.rb'
require_relative '../netflix.rb'

RSpec.describe Netflix do
  subject(:netflix) { Netflix.new('./spec/movies.txt')}

  context '#show' do
    it 'how some film now' do
      expect(netflix.show).to match(/Now showing:/)
    end

    it 'return random film' do
      expect((1..10).collect { netflix.show }.uniq.count).not_to eq 1
    end
  end

  it '#how_much? should return movie price' do
    expect(netflix.how_much?('The Terminator')).to eq 3
  end
end
