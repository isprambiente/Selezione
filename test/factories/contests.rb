# frozen_string_literal: true

FactoryBot.define do
  sequence(:contest_code) { |n| "code_#{n}" }
  sequence(:contest_title) { |n| "title_#{n}" }
  factory :contest do
    code              { generate(:contest_code) }
    title             { generate(:contest_title) }
    start_at          { Time.zone.now - 1.hour }
    stop_at           { Time.zone.now + 1.day }
    areas_max_choice  { 1 }
    factory :contest_future do
      start_at        { Time.zone.now + 1.day }
      stop_at         { Time.zone.now + 2.day }
    end
    factory :contest_ended do
      start_at        { Time.zone.now - 2.day }
      stop_at         { Time.zone.now - 1.day }
    end
  end
end
