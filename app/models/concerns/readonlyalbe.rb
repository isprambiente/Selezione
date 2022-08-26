# app/models/concerns/readonlyalbe.rb
module Readonlyalbe
  extend ActiveSupport::Concern

  included do
    delegate :active?, :status_editing?, :stop_at, to: :request, allow_nil: true
  end

  def editable?
    status_editing? && active?
  end

  def readonly?
    !editable?
  end
end
