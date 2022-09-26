require "application_system_test_case"

class User::QualificationsTest < ApplicationSystemTestCase
  setup do
    @user_qualification = user_qualifications(:one)
  end

  test "visiting the index" do
    visit user_qualifications_url
    assert_selector "h1", text: "Qualifications"
  end

  test "should create qualification" do
    visit user_qualifications_url
    click_on "New qualification"

    fill_in "Category", with: @user_qualification.category
    fill_in "Duration", with: @user_qualification.duration
    fill_in "Duration type", with: @user_qualification.duration_type
    fill_in "Istitute", with: @user_qualification.istitute
    fill_in "Title", with: @user_qualification.title
    fill_in "Vote", with: @user_qualification.vote
    fill_in "Vote type", with: @user_qualification.vote_type
    fill_in "Year", with: @user_qualification.year
    click_on "Create Qualification"

    assert_text "Qualification was successfully created"
    click_on "Back"
  end

  test "should update Qualification" do
    visit user_qualification_url(@user_qualification)
    click_on "Edit this qualification", match: :first

    fill_in "Category", with: @user_qualification.category
    fill_in "Duration", with: @user_qualification.duration
    fill_in "Duration type", with: @user_qualification.duration_type
    fill_in "Istitute", with: @user_qualification.istitute
    fill_in "Title", with: @user_qualification.title
    fill_in "Vote", with: @user_qualification.vote
    fill_in "Vote type", with: @user_qualification.vote_type
    fill_in "Year", with: @user_qualification.year
    click_on "Update Qualification"

    assert_text "Qualification was successfully updated"
    click_on "Back"
  end

  test "should destroy Qualification" do
    visit user_qualification_url(@user_qualification)
    click_on "Destroy this qualification", match: :first

    assert_text "Qualification was successfully destroyed"
  end
end
