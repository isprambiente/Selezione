# frozen_string_literal: true

# This controller manage the {Contests} access for unauthenticated users and normal users
class ContestsController < ApplicationController
  before_action :set_contest, only: %i[ show ]

  # GET /contests or /contests.json
  def index
  end

  # GET /contests/list
  def list
    type = filter_params[:type] == 'ended' ? 'ended' : 'active'
    @text = ['title ilike :text or code ilike :text', { text: "%#{filter_params[:text]}%" }] if filter_params[:text].present?
    #@group = { group: filter_params[:group] } if filter_params[:group].present?
    @pagy, @contests = pagy(Contest.send(type).where(@text).includes(:areas, :profiles), items: 12)
  end

  # GET /contests/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contest
      @contest = Contest.find(params[:id])
    end

    # Filter params for contests search
    def filter_params
      params.fetch(:filter, {}).permit(:text, :type, :group)
    end
end
