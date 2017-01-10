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
end
