require "test_helper"

class ContestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contest_1 = create :contest
    @contest_2 = create :contest
  end

  test "should get index" do
    get contests_url
    assert_response :success
  end

  test "should get list" do
    get list_contests_url
    assert_response :success
  end

  test "should show contest" do
    get contest_url(@contest_1)
    assert_response :success
  end
end
