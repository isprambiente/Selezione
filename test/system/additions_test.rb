# frozen_string_literal: true

require 'application_system_test_case'

class AdditionsTest < ApplicationSystemTestCase
  setup do
    @addition = additions(:one)
  end

  test 'visiting the index' do
    visit additions_url
    assert_selector 'h1', text: 'Additions'
  end

  test 'should create addition' do
    visit additions_url
    click_on 'New addition'

    fill_in 'Description', with: @addition.description
    fill_in 'Url', with: @addition.url
    click_on 'Create Addition'

    assert_text 'Addition was successfully created'
    click_on 'Back'
  end

  test 'should update Addition' do
    visit addition_url(@addition)
    click_on 'Edit this addition', match: :first

    fill_in 'Description', with: @addition.description
    fill_in 'Url', with: @addition.url
    click_on 'Update Addition'

    assert_text 'Addition was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Addition' do
    visit addition_url(@addition)
    click_on 'Destroy this addition', match: :first

    assert_text 'Addition was successfully destroyed'
  end
end
