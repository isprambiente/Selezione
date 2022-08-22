# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable

  has_many :requests, dependent: :destroy

  validates :tax_code, presence: true
  validates :name, presence: true
  validates :surname, presence: true

  default_scope { order('surname asc, name asc') }
end
