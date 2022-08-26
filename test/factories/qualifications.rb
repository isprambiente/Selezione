FactoryBot.define do
  factory :qualification do
    request
    category { :dsg }
    title { 'dsg title' }
    vote { '110' }
    vote_type { '110' }
    year { 2022 }
    istitute { 'my istitute' }
    duration { 'MyString' }
    duration_type { 'ore' }
    file { nil }
  end
end
