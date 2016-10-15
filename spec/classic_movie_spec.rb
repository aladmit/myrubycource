require 'spec_helper.rb'
require_relative '../classic_movie.rb'

RSpec.describe ClassicMovie do
  subject(:movie) { ClassicMovie.new({url: 'http://imdb.com/title/tt0046911/?ref_=chttp_tt_190',
                                        title: 'Diabolique',
                                        year: 1955,
                                        country: 'France',
                                        date: '1955-11-21',
                                        genre: 'Drama,Horror,Thriller',
                                        duration: '116 min',
                                        start: '8.2',
                                        producer: 'Henri-Georges Clouzot',
                                        actors: 'Simone Signoret,Véra Clouzot,Paul Meurisse'
                                       },[])
                     }

  its(:to_s) { should eq "#{movie.title} - классический фильм, режиссер #{movie.producer}" }
end
