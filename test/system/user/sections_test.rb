# frozen_string_literal: true

require 'application_system_test_case'

class User::SectionsTest < ApplicationSystemTestCase
  setup do
    @user_section = user_sections(:one)
  end

  test 'visiting the index' do
    visit user_sections_url
    assert_selector 'h1', text: 'Sections'
  end

  test 'should create section' do
    visit user_sections_url
    click_on 'New section'

    fill_in 'Title', with: @user_section.title
    click_on 'Create Section'

    assert_text 'Section was successfully created'
    click_on 'Back'
  end

  test 'should update Section' do
    visit user_section_url(@user_section)
    click_on 'Edit this section', match: :first

    fill_in 'Title', with: @user_section.title
    click_on 'Update Section'

    assert_text 'Section was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Section' do
    visit user_section_url(@user_section)
    click_on 'Destroy this section', match: :first

    assert_text 'Section was successfully destroyed'
  end
end
