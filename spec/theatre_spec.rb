require 'spec_helper.rb'
require_relative '../theatre.rb'

RSpec.describe Netflix do
  context '#show' do
    subject(:theatre) { Theatre.new('./spec/movies.txt')}

    it 'how some film now' do
      expect(theatre.show).to match(/Now showing:/)
    end

    it 'return random film' do
      expect((1..10).collect { theatre.show }.uniq.count).not_to eq 1
    end
  end
end
