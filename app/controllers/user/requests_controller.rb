# frozen_string_literal: true

# this controller manage the {Request} views.
# Only authenticated users can access to this controller
# Each user access to this controller scoped by his user_id
#
# === Before action
# * authenticate_user! for all action
# * check_right! for all action
# * {set_request} for {show}, {edit}, {update}, {destroy}
# * {set_requests} for {index}
class User::RequestsController < User::ApplicationController
  before_action :set_request, only: %i[show edit update]
  before_action :set_requests, only: %i[index]

  # GET /users/:user_id/requests
  def index; end

  # GET /users/:user_id/requests/1
  def show; end

  # GET /users/:user_id/requests/1/edit
  def edit; end

  # POST users/:user_id/requests
  def create
    @request = current_user.requests.find_or_create_by(profile_id: create_request_params[:profile_id])
    if @request.persisted?
      redirect_to user_request_url(current_user, @request)
    else
      record_not_found
    end
  end

  # PATCH/PUT /user/:user_id/requests/1
  def update
    if @request.switch!(update_request_params[:confirm])
      redirect_to user_request_url(current_user, @request), notice: 'Request was successfully updated.'
    else
      redirect_to edit_user_request_url(current_user, @request), aliert: 'Request updated fail'
    end
  end

  private

  # Set @request from param :id
  def set_request
    @request = current_user.requests.includes(profile: { area: :contest }).find(params[:id])
    @profile = @request.profile
    @area = @profile.area
    @contest = @area.contest
  end

  # Set @pagy, @contests filtered by {filter_params}
  def set_requests
    scope = ['active','ended'].include?(filter_params[:type]) ? filter_params[:type] : 'all_included'
    @text = ['profiles.title ilike :text or areas.title ilike :text or contests.title ilike :text', { text: "%#{filter_params[:text]}%" }] if filter_params[:text].present?
    @pagy, @requests = pagy(current_user.requests.send(scope).where(@text).order(:id), items: 12)
  end

  # Filter params for contests search
  def filter_params
    params.fetch(:filter, {}).permit(:text, :type)
  end

  # Filter params for create {Request}
  def create_request_params
    params.require(:request).permit(:profile_id)
  end

  # Filter params for create {Request}
  def update_request_params
    params.require(:request).permit(:confirm)
  end
end
