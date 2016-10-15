require 'spec_helper.rb'
require_relative '../movies.rb'

RSpec.describe ClassicMovie do
  before { @films = MovieCollection.new('./spec/movies.rb') }
  subject(:movie) { @films.filter(:year, 1946..1968)[0] }

  its(:to_s) { should eq "Angry Men - классический фильм, режиссер Sidney Lumet\nOther films of producer:\n  Network\n  Dog Day Afternoon" }
end
