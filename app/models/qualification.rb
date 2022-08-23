# frozen_string_literal: true

# This model manage the {Qualification} object. A {Qualification} is an educational qualification refered to a {Request}
#
# === Relations
# * belongs to {Request}
#
# === Validations
# * presence of {Request}
# * presence of {title}
# * presence of {vote} if {votable?}
# * presence of {vote_type} if {votable?}
# * inclusion of {vote_type} in VOTE_TYPE if {votable?}
# * presence of {year}
# * presence of {istitute}
# * presence of {duration} if {category_training?}
# * presence of {duration_type} if {category_training?}
# * inclusion of {duration_type} in DURATION_TYPE if {category_training?}
#
# @!attribute [rw] id
#   @return [Integer] unique identifier
# @!attribute [rw] request_id
#   @return [Integer] {Request} reference
# @!attribute [rw] category
#   @return [String] category of qualification
# @!attribute [rw] title
#   @return [String] descriptive title of qualification
# @!attribute [rw] vote
#   @return [String] vote of qualification
# @!attribute [rw] vote_type
#   @return [String] typology of vote
# @!attribute [rw] year
#   @return [Integer] year of the qualification
# @!attribute [rw] istitute
#   @return [String] name of the issuing institution
# @!attribute [rw] duration
#   @return [String] duration of training
# @!attribute [rw] duration_type
#   @return [String] unit of measurement for duration of training
class Qualification < ApplicationRecord
  CATEGORIES = {dsg: 'dsg', lvo: 'lvo', lb: 'lb', lm: 'lm', phd: 'phd', training: 'training'}
  VOTE_TYPE = ['10','30','60','100','110','altro']
  DURATION_TYPE = ['ore','giorni','mesi','anni','altro']
  belongs_to :request
  has_one_attached :file

  delegate :active, to: :request, allow_nil: true
  enum category: CATEGORIES, _prefix: true

  validates :request, presence: true
  validates :title, presence: true
  validates :year, presence: true
  validates :istitute, presence: true
  with_options if: :votable? do |e|
    e.validates :vote, presence: true
    e.validates :vote_type, presence: true, inclusion: {in: VOTE_TYPE}
  end
  with_options if: :category_training? do |e|
    e.validates :duration, presence: true
    e.validates :duration_type, presence: true, inclusion: {in: DURATION_TYPE}
  end

  before_validation :clear_superfluous_data!

  # test if {category} require a {vote}
  # @return [Boolean] true if {vote} is required
  def votable?
    ['dsg','lvo','lb','lm'].include? category
  end

  # clear unused data for category
  # @return [True]
  def clear_superfluous_data!
    if votable?
      assign_attributes duration: '', duration_type: ''
    else
      assign_attributes vote: '', vote_type: ''
    end
    true
  end
end
