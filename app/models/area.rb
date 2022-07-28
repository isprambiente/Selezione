# frozen_string_literal: true

# This model manage the {Area} object. An {Area} group many contest profile.  
# In some case an {User} can't send request in more {Area}s of same {Contest},
# this option is managed with {Contest#areas_max_choice}
#
# === Relations
# belongs to {Contest}
# has many {Profile}
# === Validates
# * presence of {Contest}
# * presence of {title}
# * presence of {profiles_max_choice}
# * numericality of {profiles_max_choice}
#
# @!attribute [rw] id
#   @return [Integer] unique identifier
# @!attribute [rw] contest_id
#   @return [Integer] {Contest} references
# @!attribute [rw] code
#   @return [String] area code
# @!attribute [rw] title
#   @return [String] Descriptive title 
# @!attribute [rw] profiles_max_choice 
#   @return [Integer] max requestable profiles for {User}
# @!attribute [rw] profiles_count
#   @return [Integer] counter cache value for {Profile}
# @!attribute [rw] created_at
#   @return [DateTime] when the record was created
# @!attribute [rw] updated_at
#   @return [DateTime] when the record was updated
# @!attribute [rw] body
#  @return [Object] ActionText instance
#
# @!method active?()
#   @return [Boolean] related {Contest#active?}
class Area < ApplicationRecord
  belongs_to :contest, counter_cache: true
  has_many :profiles, dependent: :destroy
  has_rich_text :body
 
  validates :contest, presence: true
  validates :title, presence: true
  validates :profiles_max_choice, presence: true, numericality: {only_integer: true}

  delegate :active?, to: :contest, allow_nil: true

  default_scope { order('title asc') }
end
