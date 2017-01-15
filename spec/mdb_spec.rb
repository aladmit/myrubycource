require 'spec_helper.rb'
require './mdb_client.rb'

RSpec.describe MDBClient do
  before(:all) { @client = MDBClient.new }

  describe '#movies_list', vcr: { cassette_name: 'imdb/list' } do
    it 'should return all list of top rated movies' do
      expect(@client.movies_list.length).to eq 250
    end

    describe 'movie should contain' do
      subject(:movie) do
        @client.movies_list.select { |m| m[:title] == 'Побег из Шоушенка' }.first
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

  describe '#save_movies_budget', vcr: { cassette_name: 'imdb/parse_all_movies' } do
    it 'should parse movies' do
      expect(@client).to receive(:parse_movie_budget).and_call_original.exactly(250).times
      @client.movies_budgets
    end

    it 'should save budgets to file' do
      yaml = YAML.load(File.open('./budgets.yml'))

      expect(yaml.first[:title]).to eq 'Побег из Шоушенка'
      expect(yaml.first[:budget]).to eq '$25,000,000'
    end

    it 'should add budget to movies' do
      movie = @client.movies_list.select { |m| m[:title] == 'Побег из Шоушенка' }.first
      expect(movie[:budget]).to eq '$25,000,000'
    end
  end

  describe '#save_page', :type => :aruba do
    before(:all) { @client.save_page }
    let(:file) { 'results.html' }

    it 'should create .html file' do
      expect(file).to be_an_existing_file
    end

    it 'file sould contain titles' do
      @client.movies_list.map do |movie|
        expect(file).to have_file_content movie[:titles]['US']
      end
    end

    it 'file should contain posters' do
      @client.movies_list.map do |movie|
        expect(file).to have_file_content movie[:poster]
      end
    end

    it 'file should contain budget' do
      @client.movies_list.map do |movie|
        expect(file).to have_file_content movie[:budget]
      end
    end
  end
end