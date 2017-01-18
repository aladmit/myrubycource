require 'spec_helper.rb'
require './mdb_client.rb'

RSpec.describe MDBClient, vcr: { cassette_name: 'mdbclient' } do
  subject(:client) { MDBClient.new }

  describe '#movies_list' do
    it 'should return all list of top rated movies' do
      expect(client.movies_list.length).to eq 250
    end

    it 'should parse all 250 movies' do
      expect(client).to receive(:parse_rated_movie).and_call_original.exactly(250).times
      client.movies_list
    end

    describe 'movies should contain' do
      subject(:movie) do
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
