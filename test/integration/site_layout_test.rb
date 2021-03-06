require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
  	@user = users(:michael)
  end
	test "the truth" do
     log_in_as(@user)
      assert true


	  get root_path
	  assert_template 'static_pages/home'
	  assert_select "a[href=?]", root_path, count: 2
	  assert_select "a[href=?]", help_path
	  assert_select "a[href=?]", about_path
	  assert_select "a[href=?]", contact_path
	  assert_select "a[href=?]", users_path

		get contact_path
		assert_select "title", full_title("Contact")

		get signup_path
		assert_select "title", full_title("Sign up")

   end
   test "log out the truth" do
	  get root_path
	  assert_template 'static_pages/home'
	  assert_select "a[href=?]", root_path, count: 2
	  assert_select "a[href=?]", help_path
	  assert_select "a[href=?]", about_path
	  assert_select "a[href=?]", contact_path
	  assert_select "a[href=?]", login_path

	  	get contact_path
		assert_select "title", full_title("Contact")

		get signup_path
		assert_select "title", full_title("Sign up")
   end
end
