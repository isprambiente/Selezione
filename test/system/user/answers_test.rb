require "application_system_test_case"

class User::AnswersTest < ApplicationSystemTestCase
  setup do
    @user_answer = user_answers(:one)
  end

  test "visiting the index" do
    visit user_answers_url
    assert_selector "h1", text: "Answers"
  end

  test "should create answer" do
    visit user_answers_url
    click_on "New answer"

    fill_in "Value", with: @user_answer.value
    click_on "Create Answer"

    assert_text "Answer was successfully created"
    click_on "Back"
  end

  test "should update Answer" do
    visit user_answer_url(@user_answer)
    click_on "Edit this answer", match: :first

    fill_in "Value", with: @user_answer.value
    click_on "Update Answer"

    assert_text "Answer was successfully updated"
    click_on "Back"
  end

  test "should destroy Answer" do
    visit user_answer_url(@user_answer)
    click_on "Destroy this answer", match: :first

    assert_text "Answer was successfully destroyed"
  end
end
