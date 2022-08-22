# frozen_string_literal: true

# default activerecord record class
# This class contain all methods shared for any model
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
