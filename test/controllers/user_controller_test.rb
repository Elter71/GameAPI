require 'test_helper'

class UserControllerTest < ActionController::TestCase
  #### User/new
  test 'Post User/new wrong params' do
    post :new

    body = JSON.parse(response.body)
    expected = Response.new(0)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'Post User/new wrong token' do
    post :new, params: { number: 1234, password: 'pass', character_name: 'n', token: 'sad' }

    body = JSON.parse(response.body)
    expected = Response.new(1)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'Post User/new user allready exist' do
    User.create(number: 1, password: 'j', character_name: 'sd')
    token = JSON.parse(RegisterToken.instance.to_json)

    post :new, params: { number: 1, password: 'j', character_name: 'n', token: token['token'] }

    body = JSON.parse(response.body)
    expected = Response.new(3)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'Post User/new OK' do
    token = JSON.parse(RegisterToken.instance.to_json)

    post :new, params: { number: 1, password: 'j', character_name: 'n', token: token['token'] }

    body = JSON.parse(response.body)
    expected = Response.new(99)
    user = User.find(1)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    assert user, "User don't exist"
  end
  test 'Post User/new character name is used' do
    User.create(number: 4, password: 'j', character_name: 'n')
    token = JSON.parse(RegisterToken.instance.to_json)

    post :new, params: { number: 1, password: 'j', character_name: 'n', token: token['token'] }

    body = JSON.parse(response.body)
    expected = Response.new(4)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end

  #### User/login
  test 'Post User/login wrong params' do
    post :login

    body = JSON.parse(response.body)
    expected = Response.new(0)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'Post User/login wrong number or password error token has wrong password' do
    User.create(number: 1, password: 'j', character_name: 'n')
    post :login, params: { token: 'MTpkZmdoamts' }

    body = JSON.parse(response.body)
    expected = Response.new(2)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'Post User/login wrong number or password error token is worng' do
    User.create(number: 1, password: 'j', character_name: 'n')
    post :login, params: { token: 'sdfghjkl' }

    body = JSON.parse(response.body)
    expected = Response.new(2)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'Post User/login OK' do
    User.create(number: 1, password: 'j', character_name: 'n')
    post :login, params: { token: 'MTpq' }

    body = JSON.parse(response.body)
    expected = Response.new(99)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    assert User.exists?(number: 1), "User doesn't exists"
  end
  #### User/delete
  test 'Post User/delete wrong params' do
    post :delete
    body = JSON.parse(response.body)
    expected = Response.new(0)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'Post User/delete wrong token' do
    User.create(number: 1, password: 'j', character_name: 'n')
    post :delete, params: { token: 'dfghjkl' }

    body = JSON.parse(response.body)
    expected = Response.new(2)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'Post User/delete OK' do
    User.create(number: 1, password: 'j', character_name: 'n')
    post :delete, params: { token: 'MTpq' }

    body = JSON.parse(response.body)
    expected = Response.new(99)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    assert !User.exists?(number: 1), 'User exists'
  end

  #### User/update
  test 'Post User/update wrong params' do
    post :update, params: { token: 'MTpq' }

    body = JSON.parse(response.body)
    expected = Response.new(0)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'Post User/update wrong number or password token is wrong' do
    User.create(number: 1, password: 'j', character_name: 'n')
    post :update, params: { token: 'zdfghj', password: 'jj' }

    body = JSON.parse(response.body)
    expected = Response.new(2)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'Post User/update wrong  password token has wrong password' do
    User.create(number: 1, password: 'j', character_name: 'n')
    post :update, params: { token: 'MTpkZmdoamts', password: 'jj' }

    body = JSON.parse(response.body)
    expected = Response.new(2)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'Post User/update OK' do
    password = User.create(number: 1, password: 'j', character_name: 'n').password
    post :update, params: { token: 'MTpq', password: 'asdsf' }

    body = JSON.parse(response.body)
    expected = Response.new(99)
    user = User.find_by_id_from_token('MTpq')

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    assert user.password != password, "User password hasn't be change"
  end
end
