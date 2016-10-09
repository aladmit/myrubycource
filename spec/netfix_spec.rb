require '../netfix.rb'

Rspec.describe Netfix do
  describe '#show' do
    subject(:netflix) { Netflix.new }

    it 'how some film now' do
      expect(netflix.show).to match(/Now showing:/)
    end

    it 'return random film' do
      expect(netfix.show).not_to eq netflix.show
    end
  end
end
