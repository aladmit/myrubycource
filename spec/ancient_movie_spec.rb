require 'spec_helper.rb'
require '../ancient_movie.rb'

RSpec.descripbe AncientMovie do
  subject(:movie) { AncientMovie.new('http://imdb.com/title/tt0012349/?ref_=chttp_tt_96',
                                     'The Kid',
                                     1921,
                                     'USA',
                                     '1921-02-06',
                                     'Comedy,Drama,Family',
                                     '68 min',
                                     '8.4',
                                     'Charles Chaplin',
                                     'Charles Chaplin,Edna Purviance,Jackie Coogan'
                                    )}

  it 'have to_s formant' do
    expect(movie.to_s).to eq "{movie.title} - старый фильм (#{movie.year} год)"
  end
end
