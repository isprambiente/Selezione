# frozen_string_literal: true

# This model manage the {Qualification} views
# Only authenticated users can access on this controller
# Each user access to this controller scoped by his user_id
#
# === before_action
# * authenticate_user! for all action
# * check_right! for all action
# * {Requestable#set_prerequisite} for all
# * {set_request} for {show}, {edit}, {update}, {destroy}
# * {set_requests} for {index}

class User::QualificationsController < User::ApplicationController
  include Requestable
  before_action :set_qualification, only: %i[show edit update destroy]

  # GET /users/:user_id/requests/:request_id/qualifications
  def index
    @qualifications = @user_request.qualifications
    partial_selector qualifications: @qualifications
  end

  # GET /user/:user_id/requests/:request_id/qualifications/1
  def show
    partial_selector qualification: @qualification
  end

  # GET /user/:user_id/requests/:request_id/qualifications/new
  def new
    @qualification = Qualification.new
    partial_selector qualification: @qualification
  end

  # GET /user/:user_id/requests/:request_id/qualifications/1/edit
  def edit
    partial_selector qualification: @qualification
  end

  # POST /user/:user_id/requests/:request_id/qualifications
  def create
    @qualification = @user_request.qualifications.new(qualification_params)

    if @qualification.save
      redirect_to user_request_qualifications_url(current_user, @user_request), notice: 'Qualification was successfully created.'
    else
      partial_selector 'new', qualification: @qualification
    end
  end

  # PATCH/PUT /user/:user_id/requests/:request_id/qualifications/1
  def update
    if @qualification.update(qualification_params)
      redirect_to user_request_qualification_url(current_user, @user_request, @qualification), notice: 'Qualification was successfully updated.'
    else
      partial_selector 'edit', qualification: @qualification
    end
  end

  # DELETE /user/:user_id/requests/:request_id/qualifications/1
  def destroy
    @qualification.destroy
    redirect_to user_request_qualifications_url(current_user, @user_request), notice: 'Qualification was successfully destroyed.'
  end

  private

  # Set @qualification with params :id
  # @return [Object] {Addition} istance.
  def set_qualification
    @qualification = @user_request.qualifications.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def qualification_params
    params.require(:qualification).permit(:category, :title, :vote, :vote_type, :year, :istitute, :duration, :duration_type)
  end
end
