# frozen_string_literal: true

# This model manage the {Section} object. A {Section} is a section of the
# profiles, contain the questions needed for the partecipation {Request}
#
# === Relations
# belongs to {Profile}
# has many {Question}
#
# === Validates
# * presence of {title}
#
# @!attribute [rw] id
#   @return [Integer] unique identifier
# @!attribute [rw] title
#   @return [String] identificative title
# @!attribute [rw] top
#   @return [Object] descriptive rich_text on top of section
# @!attribute [rw] bottom
#   @return [Object] descriptive rich_text on bottom of section
# @!attribute [rw] weight
#   @return [Integer] value for section order
class Section < ApplicationRecord
  include Weightable
  belongs_to :profile
  has_many :questions
  has_rich_text :top
  has_rich_text :bottom

  validates :title, presence: true
end
