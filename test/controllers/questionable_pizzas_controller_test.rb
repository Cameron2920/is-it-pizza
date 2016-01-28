require 'test_helper'

class QuestionablePizzasControllerTest < ActionController::TestCase
  test "should get ask_cam_new" do
    get :ask_cam_new
    assert_response :success
  end

end
