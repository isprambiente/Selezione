# frozen_string_literal: true

FactoryBot.define do
  factory :career do
    request
    employer { 'MyEmployer' }
    category { 'td' }
    description { 'MyDescription' }
    start_on { Time.zone.today - 1.year }
    stop_on { Time.zone.today - 6.months }
  end
end
