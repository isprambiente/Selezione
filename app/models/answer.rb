# frozen_string_literal: true

# Manage {Quesion}s answer. Each answer is referred to a {Request}
#
# === Relations
#   - belongs to {Request}
#   - belongs to {question}
#   - has one attached File
# === Validations
# * presence of {Request}
# * presence of {Quesion}
# * presence of {value} unless {category} is "file"
# * presence of {file} if {category} is "file"
# * absence of {value} if {category} is "file"
# * absence of {file} unles category is file
# * uniqueness of question scoped request
# * that {value} is included in {Option} if {question is selectable}
#
# @!method category()
#   @return [String] delegated from {Question#category}
# @!method category_file?()
#   @return [String] delegated from {Question#category}
# @!method category_select()
#   @return [String] delegated from {Question#category}
# @!method options()
#   @return [Array] delegated from {Question}
class Answer < ApplicationRecord
  include Readonlyalbe
  belongs_to :request
  belongs_to :question
  has_one_attached :file

  delegate :category, :category_file?, :options, :mandatory, :multiselectable?, :selectable?, to: :question, allow_nil: true

  # validates :request, presence: true
  # validates :question, presence: true
  validates :question, uniqueness: { scope: :request }
  validates :question_request_valid?, presence: true
  with_options if: :category_file? do
    validates :file, presence: true
    validates :value, absence: true
  end
  with_options unless: :category_file? do
    validates :file, absence: true
    validates :value, presence: true
    validates :value_in_option?, presence: true, if: :selectable?
    validates :values_in_option?, presence: true, if: :multiselectable?
  end

  # Make array from {value}
  # @return [Array] split value with "|" char as separator
  def multivalue
    value.split('|')
  end

  # Join an array with "|" char as separator and set {value}
  # @param [Array] list
  # @return [String] new {value}
  def multivalue=(list)
    self.value = list.join('|')
  end

  # Test if value is an {Option#acceptable}
  # @return [Boolean] true if is valid
  def value_in_option?
    options.acceptable.exists?(title: value)
  end

  # Test if all value from {multivalue} are {Option#acceptable}
  # @return [Boolean] true if all values are valid
  def values_in_option?
    options.where(title: multivalue, acceptable: true).count == multivalue.length
  end

  # Test if request_id is same of question.section.request_id
  # @return [Boolean] true if request is same for question and answere
  def question_request_valid?
    if question.present? && request.present?
      request.profile_id == question.section.profile_id
    else
      false
    end
  end
end
