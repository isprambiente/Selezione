# frozen_string_literal: true

FactoryBot.define do
  sequence(:area_title) { |n| "title_#{n}" }
  factory :area do
    contest
    title { generate(:area_title) }
    profiles_max_choice { 1 }
  end
end
