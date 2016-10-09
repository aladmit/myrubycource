require 'spec_helper.rb'
require_relative '../netflix.rb'

RSpec.describe Netflix do
  context '#show' do
    subject(:netflix) { Netflix.new('./spec/movies.txt')}

    it 'how some film now' do
      expect(netflix.show).to match(/Now showing:/)
    end

    it 'return random film' do
      expect(netflix.show).not_to eq netflix.show
    end
  end
end
