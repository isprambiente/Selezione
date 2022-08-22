# frozen_string_literal: true

FactoryBot.define do
  factory :template do
    title { 'MyString' }
    data do
      {
        areas_max_choice: 1,
        areas_attributes: [
          {
            code: 'a01',
            title: 'area one',
            profiles_max_choice: 1,
            profiles_attributes: [
              {
                code: 'p01',
                title: 'Profile one',
                careers_enabled: true,
                careers_requested: 12,
                qualifications_enabled: true,
                qualifications_requested: [],
                qualifications_alternative: [],
                sections_attributes: [{ title: 'Section one', weight: 0 }]
              }
            ]
          }
        ]
      }
    end
  end
end
