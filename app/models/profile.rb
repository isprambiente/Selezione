# frozen_string_literal: true

# This model manage the {Profile} object. A {Profile} is a job offer,
# each {Profile} has specific partecipation prerequisites and conditions.
# Each {Profile} is referenced to an {Contest} through an {Area}
#
# === Relations
# belongs to {Area}
# has many {Section}
# has many {Question} through {Section}
# has many {Request}
#
# === Validates
# * presence of {Area}
# * presence of {title}
# * presence of {careers_requested}
# * numericality of {careers_requested}
#
# @!attribute [rw] id
#   @return [Integer] unique identifier
# @!attribute [rw] area_id
#   @return [Integer] {Area} references
# @!attribute [rw] code
#   @return [String] profile code
# @!attribute [rw] title
#   @return [String] Descriptive title
# @!attribute [rw] careers_enabled
#   @return [Boolean] true if [Career] section is enabled for {Request}
# @!attribute [rw] careers_requested
#   @return [Integer] Requested {Career} month  for each {Request}
# @!attribute [rw] qualifications_enabled
#   @return [Boolean] true if [Qualification] section is enabled for {Request}
# @!attribute [rw] qualifications_requested
#   @return [Array] list of [Qualification] required for {Request}
# @!attribute [rw] qualifications_alternative
#   @return [Array] list of [Qualification] alternative to {careers_requested} for {Request}
# @!attribute [rw] others_enabled
#   @return [Integer] true if [Other] section is enabled for {Request}
# @!attribute [rw] body
#  @return [Object] ActionText instance
#
# @!method active?()
#   @return [Boolean] delegated from {Area#active?}
# @!method ended?()
#   @return [Boolean] delegated from {Area#ended?}
class Profile < ApplicationRecord
  belongs_to :area, counter_cache: true
  has_many :sections, dependent: :destroy
  has_many :questions, through: :sections
  has_many :requests, dependent: :destroy
  has_rich_text :body

  accepts_nested_attributes_for :sections

  validates :area, presence: true
  validates :title, presence: true
  validates :careers_requested, presence: true, numericality: { only_integer: true }

  delegate :active?, :ended?, to: :area, allow_nil: true
end
