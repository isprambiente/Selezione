# frozen_string_literal: true

# This controller is the common anchestor and contain all shared methods
#
# === Rescue
# RecordNotFound with {record_not_found!}
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found!
  include Pagy::Backend
  around_action :switch_locale

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  # render status 404
  def record_not_found!
    render 'errors/error_404', layout: true, status: :not_found
  end

  # render status 402
  def unauthorized!
    render 'errors/error_401', layout: true, status: :unauthorized
  end

  def destroy_message(obj)
    status = obj.destroyed? ? 'success' : 'fail'
    I18n.t "site.generic.destroy_#{status}"
  end
end
