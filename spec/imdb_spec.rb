require 'spec_helper.rb'
require './imdb_client.rb'

RSpec.describe IMDBClient do
  let(:client) { IMDBClient.new }

  describe '#movies_list' do
    it 'should return all list of top rated movies' do
      VCR.use_cassette('imdb/list') do
        list = client.movies_list

        expect(list.length).to eq 250
      end
    end

    it 'shoud contain title and link' do
      VCR.use_cassette('imdb/list') do
        list = client.movies_list

        expect(list.first[:title]).not_to be_empty
        expect(list.first[:link]).not_to be_empty
      end
    end
  end

  describe '#save_movies_budget' do
    it 'should parse movies' do
      VCR.use_cassette('imdb/parse_all_movies') do
        expect(client).to receive(:parse_movie_budget).and_call_original
      end
    end

    it 'should save budgets to file' do
      VCR.use_cassette('imdb/parse_all_movies') do
        expect('./budgets.yml').to be_an_existing_file

        yaml = YAML.load(File.open('./budgets.html'))
        expect(yaml.first[:title]).to eq 'Побег из Шоушенка'
        expect(yaml.first[:budget]).to eq '$25,000,000'
      end
    end
  end
end
