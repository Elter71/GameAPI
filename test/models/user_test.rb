require 'test_helper'

class UserTest < ActiveSupport::TestCase


  def setup
    @user_para = {number: 1, password: "j", character_name: "name"}
    @user = User.create(@user_para)
  end

  test 'create user' do
    assert(@user.token, "Token doesn't exist")
    assert(@user.character, "Character doesn't exist")
    assert_not_equal((@user.password.length == 256), @user_para[:password], "Password doesn't hash")
  end
  test 'token is correct' do
    user = User.find_by(number: @user_para[:number])
    token = UserToken.generate_token(@user_para[:number], @user_para[:password])
    assert(user.token_is_correct?("MTpq"), "Token isn't correct #{token}")
  end
end
