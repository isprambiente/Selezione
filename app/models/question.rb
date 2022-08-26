# frozen_string_literal: true

# Manage question for any section.
#
# === Relations
# Relations::
#   - belongs to {Section}
#   - has_many {Answer}, dependent: :destroy
#   - has_many {Option}, dependent: :destroy
#
# === Validations
# * presence of {Section}
# * presence of {title}
# * presence of {category}
# * presence of {weight}
# * presence of {mandatory}
# * presence of {options} if category is select
# * absence of {options} unless category is select
#
# @!attribute [rw] id
#   @return [Integer] unique identifier
# @!attribute [rw] section_id
#   @return [Integer] reference for {Section}
# @!attribute [rw] title
#   @return [String] question text
# @!attribute [rw] category
#   @return [String] enum of question typologies
# @!attribute [rw] weight
#   @return [Integer] Question order
# @!attribute [rw] mandatory
#   @return [Boolean] define if the answer is mandatory
# @!attribute [rw] note
#   @return [Object] ActionText istance
# @!method self.acceptable
#   @return [Array] list of related options where {acceptable} is true
class Question < ApplicationRecord
  include Weightable
  belongs_to :section
  has_many :answers, dependent: :destroy
  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: :all_blank

  enum category: { string: 'string', text: 'text', select: 'select', multiselect: 'multiselect', radio: 'radio', checkbox: 'checkbox', file: 'file' }, _prefix: true

  validates :section, presence: true
  validates :title, presence: true
  validates :weight, presence: true
  validates :category, presence: true
  validates :mandatory, inclusion: { in: [true, false], allow_nil: false }
  # validates :options, presence: true, if: :optionable?
  # validates :options, absence: true, unless: :optionable?

  scope :mandatory, -> { where mandatory: true }

  # test if {category} require a single {Answer#value} from {Option}
  # @return [Boolean] true if category if 'select' or 'radio'
  def selectable?
    %w[select radio].include?(category)
  end

  # test if {category} accepr multiple {Answer#value} from {Option}
  # @return [Boolean] true if category if 'multiselect' or 'checkbox'
  def multiselectable?
    %w[multiselect checkbox].include?(category)
  end

  # test if {category} require options
  # @return [Boolean] true if {selectable?} or {multiselectable?}
  def optionable?
    selectable? || multiselectable?
  end
end
