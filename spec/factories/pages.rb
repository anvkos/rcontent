require 'faker'
require './app/models/page'

FactoryGirl.define do
  factory :page do
    active true
    slug { Faker::Lorem.word }
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence(5) }
    image { Faker::Placeholdit.image }
    created_at { Time.now }
  end
end
