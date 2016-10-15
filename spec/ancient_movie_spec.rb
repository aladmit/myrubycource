require 'spec_helper.rb'
require_relative '../ancient_movie.rb'

RSpec.describe AncientMovie do
  subject(:movie) { AncientMovie.new({url: 'http://imdb.com/title/tt0012349/?ref_=chttp_tt_96',
                                      title: 'The Kid',
                                      year: 1921,
                                      country: 'USA',
                                      date: '1921-02-06',
                                      genre: 'Comedy,Drama,Family',
                                      duration: '68 min',
                                      stars: '8.4',
                                      producer: 'Charles Chaplin',
                                      actors: 'Charles Chaplin,Edna Purviance,Jackie Coogan'
                                     },[]
                                    )}

  its(:to_s) { should eq "#{movie.title} - старый фильм (#{movie.year} год)" }
end
