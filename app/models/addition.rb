# frozen_string_literal: true

# This model manage the {Addition} object. A {Addition} is a generic qualification refered to a {Request}
#
# === Relations
# * belongs to {Request}
#
# === Validations
# * presence of {Request}
# * presence of {description}
#
# @!attribute [rw] id
#   @return [Integer] unique identifier
# @!attribute [rw] request_id
#   @return [Integer] {Request} reference
# @!attribute [rw] description
#   @return [String] description of the qualification
# @!attribute [rw] file
#   @return [Object] ActiveStorage istance
# @!attribute [rw] url
#   @return [String] alternative url for qualification
class Addition < ApplicationRecord
  include Readonlyalbe
  belongs_to :request
  has_one_attached :file

  validates :request, presence: true
  validates :description, presence: true
end
