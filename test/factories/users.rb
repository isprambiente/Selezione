# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:tax_code) { |n| "abcdef00m01h#{n}1n" }
    name { 'nome' }
    surname { 'cognome' }
    email { 'a.b@mail.com' }
  end
end
