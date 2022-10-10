# frozen_string_literal: true

# This Controller manage the {Answer} views
# Only authenticated users can access on this controller
# Each user access to this controller scoped by his user_id
#
# === before_action
# * authenticate_user! for all action
# * check_right! for all action
# * {Requestable#set_prerequisite} for all
# * {set_request} for {show}, {edit}, {update}, {destroy}
# * {set_requests} for {index}
class User::AnswersController < User::ApplicationController
  include Requestable
  before_action :set_answer

  # PATCH/PUT /user/answers/1 or /user/answers/1.json
  def update
    # if
    @answer.update(answer_params)
    # redirect_to user_request_section_url(current_user, @request, @question.section), notice: "Answer was successfully updated."
    # else
    #  render :edit, status: :unprocessable_entity
    # end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_answer
    @question = @request.questions.find(params[:id])
    @answer = @request.answers.find_or_initialize_by(question: @question)
  end

  # Only allow a list of trusted parameters through.
  def answer_params
    params.require(:answer).permit(:value)
  end
end
