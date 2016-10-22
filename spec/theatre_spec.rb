require 'spec_helper.rb'
require_relative '../theatre.rb'

RSpec.describe Theatre do
  context '#show' do
    subject(:theatre) { Theatre.new('./spec/movies.txt') }

    it 'how some film now' do
      expect(theatre.show).to match(/Now showing:/)
    end

    it 'return random film' do
      expect((1..10).collect { theatre.show }.uniq.count).not_to eq 1
    end

    it 'return ancient film in the morning' do
      hours = 8..11
      filteres_films = hours
                        .map { |hour| theatre.filter_by_time("#{hour}:30") }
                        .flatten.uniq.map(&:title).join(' ')
      expect(filteres_films).to include(theatre.show("8:30").match(/(?<=Now showing: )[A-Za-z ]*/).to_s)
    end

    it 'return Comedy and Action in the middle of day' do
      hours = 12..16
      filteres_films = hours
                        .map { |hour| theatre.filter_by_time("#{hour}:30") }
                        .flatten.uniq.map(&:title).join(' ')
      expect(filteres_films).to include(theatre.show("14:30").match(/(?<=Now showing: )[A-Za-z ]*/).to_s)
    end

    it 'return Drama and Horror in the evening' do
      hours = 17..22
      filteres_films = hours
                        .map { |hour| theatre.filter_by_time("#{hour}:30") }
                        .flatten.uniq.map(&:title).join(' ')
      expect(filteres_films).to include(theatre.show("18:30").match(/(?<=Now showing: )[A-Za-z ]*/).to_s)
    end
  end

  context '#filter_by_time' do
    subject(:theatre) { Theatre.new('./spec/movies.txt') }

    it 'return ancient film in the morning' do
      hours = 8..11
      expect(hours.map { |hour| theatre.filter_by_time("#{hour}:00") }.flatten.map(&:class)).to all eq AncientMovie
    end

    it 'return Comedy and Action in the middle of day' do
      hours = 12..16
      expect(hours.map { |hour| theatre.filter_by_time("#{hour}:00") }.flatten.map(&:genre).flatten).to include("Action", "Comedy")
    end

    it 'return Drama and Horror in the evening' do
      hours = 17..22
      expect(hours.map { |hour| theatre.filter_by_time("#{hour}:00") }.flatten.map(&:genre).flatten).to include("Horror", "Drama")
    end
  end

  it '#when?' do
    expect(Theatre.new('./spec/movies.txt').when?('The Terminator')).to eq "С 12 до 16"
  end
end
