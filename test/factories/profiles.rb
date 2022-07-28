# frozen_string_literal: true

FactoryBot.define do
  sequence(:profile_title) {|n| "title_#{n}"}
  factory :profile do
    area
    title { generate(:profile_title) }
    careers_enabled { true }
    careers_requested { 0 }
    qualifications_enabled { true }
    qualifications_requested { [] }
    qualifications_alternative { [] }
    others_enabled { true }
  end
end
