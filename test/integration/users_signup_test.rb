require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
   test "the truth" do
     assert true
   end
  test "invalid signup information" do
  	get signup_path
  		assert_no_difference 'User.count' do
  			post users_path, params: {user: { name: "",
	  											email: "user@invalid",
	  											password:"foo",
	  											passwprd_confirmation:"bar"}}
	  	end
#	  	follow_redirect!
#	  	assert_not_template 'users/new'
#	  	assert_not flash ''
	end

  test "valid signup information" do
  	get signup_path
  		assert_difference 'User.count',1 do
  			post users_path, params: {user: { name: "Example User",
	  											email: "user@example.com",
	  											password:"password",
	  											passwprd_confirmation:"password"}}
	  	end
	  	follow_redirect!
	  	assert_template 'users/show'
	  	assert is_logged_in?
	end
end
