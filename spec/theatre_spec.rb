require 'spec_helper.rb'
require_relative '../theatre.rb'

RSpec.describe Theatre do
  context '#show' do
    subject(:theatre) { Theatre.new('./spec/movies.txt') }

    it 'how some film now' do
      expect(theatre.show).to match(/Now showing:/)
    end

    it 'use random_by_stars' do
      expect(theatre).to receive(:random_by_stars).and_call_original
      theatre.show
    end

    it 'return film with filtering by time' do
      allow(theatre).to receive(:filter_by_time).with("8:30").and_call_original
      theatre.show("8:30")
    end
  end

  context '#filter_by_time' do
    subject(:theatre) { Theatre.new('./spec/movies.txt') }

    it 'return ancient film in the morning' do
      expect(movies_at(8..11)).to all be_a(AncientMovie)
    end

    it 'return Comedy and Action in the middle of day' do
      expect(movies_at(12..16)).to all have_genres("Action", "Comedy")
    end

    it 'return Drama and Horror in the evening' do
      expect(movies_at(17..22)).to all have_genres("Horror", "Drama")
    end
  end

  context '#when?' do
    subject(:theatre) { Theatre.new('./spec/movies.txt') }

    it 'return time for movie' do
      expect(theatre.when?('The Terminator')).to eq "С 12 до 16"
    end

    it 'return exception if movie not found' do
      expect { theatre.when?('Film that not exist') }.to raise_error(MovieNotFound)
    end

    it 'return exception if time not found' do
      expect { theatre.when?('Princess Mononoke') }.to raise_error(MovieTimeNotFound)
    end
  end
end
