require 'rspec'
require 'simplecov'
require 'events/shared_examples'

SimpleCov.start

# Custom Matchers
RSpec::Matchers.define :be_boolean do
    match do |value|
        [true, false].include? value
    end
end