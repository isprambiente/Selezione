# frozen_string_literal: true

# This controller manage the {Contest} access for unauthenticated users and normal users
#
# === before_action
# * {set_contest} for {show}
# * {set_contests} for {index}
class ContestsController < ApplicationController
  before_action :set_contest, only: %i[show]
  before_action :set_contests, only: %i[index]

  # GET /contests
  def index
    Rails.logger.info 'sono qui'
    respond_to do |format|
      format.turbo_stream { render 'index' }
      format.html {}
    end
  end

  # GET /contests/1
  def show; end

  private

  # Set @contest from param :id
  def set_contest
    @contest = Contest.published.find(params[:id])
  end

  # Set @pagy, @contests filtered by {filter_params}
  def set_contests
    type = filter_params[:type] == 'ended' ? 'ended' : 'active'
    @text = ['title ilike :text or code ilike :text', { text: "%#{filter_params[:text]}%" }] if filter_params[:text].present?
    @pagy, @contests = pagy(Contest.send(type).where(@text).includes(:areas, :profiles), items: 12)
  end

  # Filter params for contests search
  def filter_params
    params.fetch(:filter, {}).permit(:text, :type, :group)
  end
end
