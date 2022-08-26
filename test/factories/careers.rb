# frozen_string_literal: true

FactoryBot.define do
  factory :career do
    request
    employer { 'MyEmployer' }
    category { 'td' }
    description { 'MyDescription' }
    start_on { Date.today - 1.year }
    stop_on { Date.today - 6.month }
  end
end
