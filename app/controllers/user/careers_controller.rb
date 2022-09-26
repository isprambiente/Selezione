class User::CareersController < User::ApplicationController
  include Requestable
  before_action :set_career, only: %i[ show edit update destroy ]

  # GET /users/:user_id/requests/:request_id/careers
  def index
    @careers = @user_request.careers
    partial_selector careers: @careers
  end

  # GET /user/:user_id/requests/:request_id/careers/1
  def show
    partial_selector career: @career
  end

  # GET /user/:user_id/requests/:request_id/careers/new
  def new
    @career = Career.new
    partial_selector career: @career
  end

  # GET /user/:user_id/requests/:request_id/careers/1/edit
  def edit
    partial_selector career: @career
  end

  # POST /user/:user_id/requests/:request_id/careers
  def create
    @career = @user_request.careers.new(career_params)

    if @career.save
      redirect_to user_request_careers_url(current_user, @user_request), notice: "Career was successfully created." 
    else
      partial_selector 'new', career: @career
    end
  end

  # PATCH/PUT /user/:user_id/requests/:request_id/careers/1
  def update
    if @career.update(career_params)
      redirect_to user_request_career_url(current_user, @user_request, @career), notice: "Career was successfully updated." 
    else
      partial_selector 'edit', career: @career
    end
  end

  # DELETE /user/:user_id/requests/:request_id/careers/1
  def destroy
    @career.destroy
    redirect_to user_request_careers_url(current_user, @user_request), notice: "Career was successfully destroyed." 
  end

  private
    
    # Set @career with params :id
    # @return [Object] {Addition} istance.
    def set_career
      @career = @user_request.careers.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def career_params
      params.require(:career).permit(:employer, :category, :description, :start_on, :stop_on)
    end
end
