require 'rspec/its'
require_relative './matchers.rb'
require_relative './support/vcr_setup.rb'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

require './netflix.rb'
RSpec.shared_examples 'movie type' do |years, movie_class|
  it "with #{movie_class} from #{years.first} to #{years.last}" do
    array_of_classes = films.filter(year: years).collect(&:class).uniq
    expect(array_of_classes.size).to eq 1
    expect(array_of_classes.first).to eq movie_class
  end
end
