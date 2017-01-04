require 'spec_helper.rb'
require './theatre.rb'
require './theatre_hall.rb'
require './theatre_period.rb'

RSpec.describe Theaters::Theatre do
  context '#show' do
    subject(:theatre) { Theaters::Theatre.new('./spec/movies.txt') }

    it 'how some film now' do
      expect(theatre.show).to match(/Now showing:/)
    end

    it 'use random_by_stars' do
      expect(theatre).to receive(:random_by_stars).and_call_original
      theatre.show
    end

    it 'return film with filtering by time' do
      allow(theatre).to receive(:filter_by_time).with('8:30').and_call_original
      theatre.show('8:30')
    end
  end

  context '#filter_by_time' do
    def movies_at(hours)
      hours.map { |hour| theatre.filter_by_time("#{hour}:00") }.flatten
    end

    subject(:theatre) { Theaters::Theatre.new('./spec/movies.txt') }

    it 'return ancient film in the morning' do
      expect(movies_at(8..11)).to all be_a(Theaters::AncientMovie)
    end

    it 'return Comedy and Action in the middle of day' do
      expect(movies_at(12..16)).to all have_genres('Action', 'Comedy')
    end

    it 'return Drama and Horror in the evening' do
      expect(movies_at(17..22)).to all have_genres('Horror', 'Drama')
    end
  end

  context '#when?' do
    subject(:theatre) { Theaters::Theatre.new('./spec/movies.txt') }

    it 'return time for movie' do
      expect(theatre.when?('The Terminator')).to eq 'С 12 до 16'
    end

    it 'return exception if movie not found' do
      expect { theatre.when?('Film that not exist') }.to raise_error(MovieNotFound)
    end

    it 'return exception if time not found' do
      expect { theatre.when?('Princess Mononoke') }.to raise_error(MovieTimeNotFound)
    end
  end

  context 'cashbox' do
    subject(:theatre) { Theaters::Theatre.new('./spec/movies.txt') }

    it '#cash return amout of money in cashbox' do
      expect(theatre.cash).to eq theatre.money
    end

    context 'get money if somebody #buy_ticket' do
      it 'get 3 dollars in morning' do
        expect { theatre.buy_ticket('8:10') }.to change { theatre.cash.cents }.by(3)
      end

      it 'get 5 dollars in day' do
        expect { theatre.buy_ticket('14:00') }.to change { theatre.cash.cents }.by(5)
      end

      it 'get 10 dollars in evening' do
        expect { theatre.buy_ticket('17:40') }.to change { theatre.cash.cents }.by(10)
      end
    end
  end

  context 'dsl' do
    it 'should create hall' do
      theatre = Theaters::Theatre.new do
        hall :red, title: 'Красный зал', places: 100
      end

      hall = theatre.class.class_variable_get(:@@halls).first
      expect(hall.class).to eq Theaters::TheatreHall
      expect(hall.color).to eq :red
      expect(hall.title).to eq 'Красный зал'
      expect(hall.places).to eq 100
    end

    context 'create period' do
      subject(:period) do
        theatre = Theaters::Theatre.new do
          hall :red, title: 'Красный зал', places: 100

          period '09:00'..'11:00' do
            description 'Утренний сеанс'
            filters genre: 'Сomedy', year: 1900..1980
            price 10
            hall :red, :blue
          end
        end

        theatre.class.class_variable_get(:@@periods).first
      end

      it 'from class' do
        expect(period.class).to eq Theaters::TheatrePeriod
      end

      it 'with time' do
        expect(period.time).to eq '09:00'..'11:00'
      end

      it 'with description' do
        expect(period.description).to eq 'Утренний сеанс'
      end

      it 'with filters' do
        expect(period.filters[:year]).to eq 1900..1980
        expect(period.filters[:genre]).to eq 'Comedy'
      end

      it 'with price' do
        expect(period.price).to eq 10
      end

      it 'with halls' do
        expect(period.hall).to include(:red, :blue)
      end
    end
  end
end
