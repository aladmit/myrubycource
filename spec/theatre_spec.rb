require 'spec_helper.rb'
require_relative '../theatre.rb'

RSpec.describe Theatre do
  context '#show' do
    subject(:theatre) { Theatre.new('./spec/movies.txt')}

    it 'how some film now' do
      expect(theatre.show).to match(/Now showing:/)
    end

    it 'return random film' do
      expect((1..10).collect { theatre.show }.uniq.count).not_to eq 1
    end

    it 'return ancient film in the morning' do
      hours = 8..12
      expect(hours.map { |hour| theatre.show("#{hour}:00") }.map(&:class)).to all eq AncientMovie
    end

    it 'return Comedy and Action in the middle of day' do
      hours = 13..15
      expect(hours.map { |hour| theatre.show("#{hour}:00") }.map(&:genre).flatten.uniq).to include("Action", "Comedy")
    end

    it 'return Drama and Horror in the evening' do
      hours = 16..20
      expect(hours.map { |hour| theatre.show("#{hour}:00") }.map(&:genre).flatten.uniq).to include("Horror", "Drama")
    end
  end
end
