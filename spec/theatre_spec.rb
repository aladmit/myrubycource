require 'spec_helper.rb'
require 'theaters'

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
      expect(movies_at(8..11)).to all be_a(Theaters::Movie::Ancient)
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
    describe '#hall' do
      subject(:hall) do
        Theaters::Theatre.new do
          hall :red, title: 'Красный зал', places: 100
        end.halls.first
      end

      its(:class) { should eq Theaters::Theatre::Hall }
      its(:color) { should eq :red }
      its(:title) { should eq 'Красный зал' }
      its(:places) { should eq 100 }
    end

    describe '#period' do
      subject(:period) do
        theatre = Theaters::Theatre.new do
          hall :red, title: 'Красный зал', places: 100

          period '09:00'..'11:00' do
            description 'Утренний сеанс'
            filters genre: 'Comedy', year: 1900..1980
            price 10
            hall :red, :blue
          end
        end

        theatre.periods.select do |p|
          p.time == ('09:00'..'11:00')
        end.first
      end

      its(:class) { should eq Theaters::Theatre::Period }
      its(:time) { should eq '09:00'..'11:00' }
      its(:description) { should eq 'Утренний сеанс' }
      its(:filters) { should include year: 1900..1980, genre: 'Comedy' }
      its(:price) { should eq 10 }
      its(:hall) { should include :red, :blue }

      it 'and get excpetion if period is cover other period' do
        expect do
          Theaters::Theatre.new do
            period '10:00'..'11:00' do
              hall :red
            end

            period '10:00'..'10:30' do
              hall :red
            end
          end
        end.to raise_error(InvalidPeriod)
      end
    end

    describe '#show' do
      subject(:theatre) do
        theatre = Theaters::Theatre.new do
          hall :green, title: 'Зеленый зал', places: 100

          period '11:00'..'16:00' do
            description 'Спецпоказ Терминатора'
            filters title: 'The Terminator'
            price 50
            hall :green
          end
        end
      end

      it 'should use filters from periods' do
        allow(theatre).to receive(:filter_by_period).with('12:00').and_call_original
        theatre.show('12:00')
      end
    end

    it 'filter_by_period apply filters from period' do
      theatre = Theaters::Theatre.new do
        hall :red, title: 'Красный зал', places: 100

        period '20:00'..'22:00' do
          description 'Вечерний сеанс'
          filters genre: 'Сomedy', year: 1900..1980
          price 10
          hall :red, :blue
        end
      end

      expect(theatre).to receive(:filter).with(genre: 'Сomedy', year: 1900..1980).and_call_original
      theatre.filter_by_period('21:00')
    end
  end
end
