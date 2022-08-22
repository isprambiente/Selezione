# frozen_string_literal: true

# This model manage the {Option} object. An {Option} is a possible answer to a {Question},
# The options are ordinated by {weight} field
# The valid answers are marked by {acceptable} field
#
# === Relations
# belongs to {Question}
#
# === Validates
# * presence of {Question} reference
# * presence of {title}
# * presence of {weight}
# * presence of {acceptable}
#
# @!attribute [rw] id
#   @return [Integer] unique identifier
# @!attribute [rw] question_id
#   @return [Integer] {Question} references
# @!attributes [rw] weight
#   @return [Integer] order value
# @!attribute [rw] acceptable
#   @return [Boolean] true if is a valid answer
#
# === Scope
# default scope is weight desc
class Option < ApplicationRecord
  belongs_to :question

  validates :question, presence: true
  validates :title, presence: true
  validates :weight, presence: true
  validates :acceptable, inclusion: [true, false]

  default_scope { order('weight desc') }
  scope :acceptable, -> { where acceptable: true }
end