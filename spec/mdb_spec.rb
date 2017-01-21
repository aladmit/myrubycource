require 'spec_helper.rb'
require './mdb_client.rb'

RSpec.describe MDBClient, vcr: { cassette_name: 'mdbclient' } do
  subject(:client) { MDBClient.new }

  describe '#load_list!' do
    it 'should load movies list' do
      expect(client).to receive(:parse_rated_movie).and_call_original.exactly(250).times

      client.load_list!
    end

    it 'should show progress bar' do
      fake_progress = ProgressBar.create(title: 'Load', total: 250)
      expect(ProgressBar).to receive(:create).and_return(fake_progress)
      expect(fake_progress).to receive(:increment).exactly(250).times

      client.load_list!
    end

    it 'not show progress bar if has option' do
      expect(ProgressBar).not_to receive(:create)
      client.load_list!(progress: false)
    end
  end

  describe '#movies_list' do
    it 'empty before load list' do
      expect(client.movies_list).to be_nil
    end

    it 'should contain movies after load_list' do
      client.load_list!(progress: false)
      expect(client.movies_list.length).to eq 250
    end

    describe 'movies should contain' do
      subject(:movie) do
        client.load_list!(progress: false)
        client.movies_list.select { |m| m[:title] == 'Побег из Шоушенка' }.first
      end

      its([:id]) { should eq 'tt0111161' }
      its([:title]) { should eq 'Побег из Шоушенка' }
      its([:link]) { should include 'tt0111161' }
      its([:poster]) { should include '.jpg' }

      it 'titles' do
        expect(movie[:titles]).to include 'AU' => 'The Shawshank Redemption - Stephen King'
      end
    end
  end

  describe '#save_movies_budget' do
    it 'should parse movies' do
      expect(client).to receive(:parse_movie_budget).and_call_original.exactly(250).times
      client.movies_budgets
    end

    it 'should save budgets to file' do
      client.movies_budgets
      yaml = YAML.load(File.open('./budgets.yml'))

      expect(yaml.first[:title]).to eq 'Побег из Шоушенка'
      expect(yaml.first[:budget]).to eq '$25,000,000'
    end

    it 'should add budget to movies' do
      movie = client.movies_list.select { |m| m[:title] == 'Побег из Шоушенка' }.first
      expect(movie[:budget]).to eq '$25,000,000'
    end
  end

  describe '#save_page' do
    let(:file) { client.save_page && File.read('results.html') }

    it 'should create .html file' do
      expect(file).not_to be_empty
    end

    it 'file sould contain titles' do
      client.movies_list.each do |movie|
        expect(file).to include(movie[:titles]['US']) if movie[:titles].has_key?('US')
      end
    end

    it 'file should contain posters' do
      client.movies_list.map do |movie|
        expect(file).to include(movie[:poster])
      end
    end

    it 'file should contain budget' do
      client.movies_list.map do |movie|
        expect(file).to include(movie[:budget])
      end
    end
  end
end
