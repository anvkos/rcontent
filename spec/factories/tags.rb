require 'faker'
require './app/models/tag'

FactoryGirl.define do
  factory :tag do
    name { Faker::Lorem.word }
    slug { Faker::Lorem.word }
    created_at { Time.now }
  end
end
