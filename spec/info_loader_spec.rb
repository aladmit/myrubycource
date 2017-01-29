require 'spec_helper'
require 'theaters/info_loader'

RSpec.describe Theaters::InfoLoader do
  subject(:client) { Theaters::InfoLoader.new }

  describe '#load_list!', vcr: true do
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

  describe '#load_budgets', vcr: true do
    it 'dont use cache by default' do
      expect(client).not_to receive(:load_cache)
      expect(client).to receive(:parse_budgets)

      client.load_list!(progress: false)
      client.load_budgets
    end

    it 'save budgets to file if cache: "file"' do
      expect(client).to receive(:load_cache)
      expect(client).to receive(:save_budgets)

      client.load_budgets(cache: 'budgets.yml')
    end
  end

  describe '#load_cache', vcr: true do
    it 'should parse budgets if file does not exist' do
      expect(client).to receive(:parse_budgets)

      client.load_list!(progress: false)
      client.load_cache('example')
    end

    it 'should load from file' do
      client.load_list!(progress: false)
      client.load_budgets(cache: './spec/text.yml')

      expect(client).not_to receive(:parse_budgets)

      client.load_budgets(cache: './spec/text.yml')
      File.delete('./spec/text.yml')
    end
  end

  describe '#parse_budgets', vcr: true do
    it '#parse_budgets should use #parse_budgets' do
      expect(client).to receive(:parse_budget).exactly(250).times

      client.load_list!(progress: false)
      client.parse_budgets
    end

    it '#parse_budget should return budget' do
      link = 'http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=2398042102&pf_rd_r=107B45XDPJTE1DK9GR1C&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_1'

      expect(client.parse_budget(link)).to eq '$25,000,000'
    end
  end

  describe '#movies_list', vcr: true do
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

  describe '#save_page', vcr: true do
    subject(:file) do
      client.load_list!(progress: false)
      client.save_page(cache: 'budgets.yml')
      File.read('results.html')
    end

    it 'should create .html file' do
      expect(file).not_to be_empty
    end

    it 'file sould contain titles' do
      client.load_list!(progress: false)
      client.movies_list.each do |movie|
        expect(file).to include(movie[:titles]['US']) if movie[:titles].has_key?('US')
      end
    end

    it 'file should contain posters' do
      client.load_list!(progress: false)
      client.movies_list.map do |movie|
        expect(file).to include(movie[:poster])
      end
    end

    it 'file should contain budget' do
      client.load_list!(progress: false)
      client.load_budgets.map do |movie|
        expect(file).to include(movie[:budget])
      end
    end
  end
end
