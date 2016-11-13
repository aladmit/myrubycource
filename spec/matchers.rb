require 'rspec/expectations'

RSpec::Matchers.define :have_genres do |*genres|
  match do |movie|
    genres.any? { |genre| movie.has_genre?(genre) }
  end
end

RSpec::Matchers.define :not_be_empty do |expected|
  match do |actual|
    !actual.empty?
  end
end
