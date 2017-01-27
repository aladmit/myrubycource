require 'rspec/expectations'

RSpec::Matchers.define :have_genres do |*genres|
  match do |movie|
    genres.any? { |genre| movie.genre?(genre) }
  end
end

RSpec::Matchers.define :from_country do |country|
  match do |movie|
    country.downcase == country.downcase
  end
end

RSpec::Matchers.define :not_be_empty do
  match do |actual|
    !actual.empty?
  end
end
