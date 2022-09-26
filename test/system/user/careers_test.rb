# frozen_string_literal: true

require 'application_system_test_case'

class User::CareersTest < ApplicationSystemTestCase
  setup do
    @user_career = user_careers(:one)
  end

  test 'visiting the index' do
    visit user_careers_url
    assert_selector 'h1', text: 'Careers'
  end

  test 'should create career' do
    visit user_careers_url
    click_on 'New career'

    fill_in 'Category', with: @user_career.category
    fill_in 'Description', with: @user_career.description
    fill_in 'Employer', with: @user_career.employer
    fill_in 'Start at', with: @user_career.start_at
    fill_in 'Stop at', with: @user_career.stop_at
    click_on 'Create Career'

    assert_text 'Career was successfully created'
    click_on 'Back'
  end

  test 'should update Career' do
    visit user_career_url(@user_career)
    click_on 'Edit this career', match: :first

    fill_in 'Category', with: @user_career.category
    fill_in 'Description', with: @user_career.description
    fill_in 'Employer', with: @user_career.employer
    fill_in 'Start at', with: @user_career.start_at
    fill_in 'Stop at', with: @user_career.stop_at
    click_on 'Update Career'

    assert_text 'Career was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Career' do
    visit user_career_url(@user_career)
    click_on 'Destroy this career', match: :first

    assert_text 'Career was successfully destroyed'
  end
end
