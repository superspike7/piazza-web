require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "redirects to feed after successful sign up" do
    get sign_up_path
    assert_response :ok

    assert_difference ["User.count", "Organization.count"], 1 do
      post sign_up_path, params: {
                           user: {
                             name: "Dryxcy",
                             email: "mamabing@gmail.com",
                             password: "password",
                             password_confirmation: "password",
                           },
                         }
    end

    assert_redirected_to root_path
    assert_not_empty cookies[:app_session]

    follow_redirect!
    assert_select ".notification.is-success",
                  text: I18n.t(
                    "users.create.welcome",
                    name: "Dryxcy",
                  )
  end

  test "renders errors if input data is invalid" do
    get sign_up_path
    assert_response :ok

    assert_no_difference ["User.count", "Organization.count"] do
      post sign_up_path, params: {
                           user: {
                             name: "",
                             email: "mamabing",
                             password: "small",
                             password_confirmation: "big",
                           },
                         }
    end

    assert_response :unprocessable_entity
    assert_select "p.is-danger",
                  text: I18n.t
    ("activerecord.errors.models.user.attributes.password.too_short")
    assert_select "p.is-danger",
                  text: I18n.t
    ("activerecord.errors.models.user.attributes.password_confirmation.confirmation")
  end
end
