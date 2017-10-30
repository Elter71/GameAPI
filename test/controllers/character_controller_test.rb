require 'test_helper'

class CharacterControllerTest < ActionController::TestCase
  test 'update statistics OK' do
    user = User.create(number: 1, password: 'j', character_name: 'name')
    Level.create(level: 1, experience_to_next: 100)

    post :update, params: { token: 'MTpq', type: 'statistics', data: { stamina: 1, strength: 1 } }

    body = JSON.parse(response.body)
    expected = Response.new(99)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    assert user.character.statistics.stamina == 2, 'stamina'
    assert user.character.statistics.strength == 2, 'strength'
    assert user.character.statistics.dexterity == 1, 'dexterity'
  end

  test 'update level OK' do
    user = User.create(number: 1, password: 'j', character_name: 'name')
    Level.create(level: 1, experience_to_next: 100)

    post :update, params: { token: 'MTpq', type: 'experience', data: { experience: 100 } }

    body = JSON.parse(response.body)
    expected = Response.new(99)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    assert user.character.statistics.experience == 100, 'experience'
  end
  test 'update wrong parameter' do
    user = User.create(number: 1, password: 'j', character_name: 'name')
    Level.create(level: 1, experience_to_next: 100)

    post :update, params: { token: 'MTpq', data: { stamina: 1, strength: 1 } }

    body = JSON.parse(response.body)
    expected = Response.new(0)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'update wrong statistics type' do
    user = User.create(number: 1, password: 'j', character_name: 'name')
    Level.create(level: 1, experience_to_next: 100)

    post :update, params: { token: 'MTpq', type: 'dfgh', data: { stamina: 1, strength: 1 } }

    body = JSON.parse(response.body)
    expected = Response.new(5)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'update wrong authorization type' do
    user = User.create(number: 1, password: 'j', character_name: 'name')
    Level.create(level: 1, experience_to_next: 100)

    post :update, params: { token: 'MsdfgTpdq', type: 'statistics', data: { stamina: 1, strength: 1 } }

    body = JSON.parse(response.body)
    expected = Response.new(2)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end

  test 'show statistics OK' do
    user = User.create(number: 1, password: 'j', character_name: 'name')

    get :show, params: { token: 'MTpq', name: 'name' }

    body = JSON.parse(response.body)
    data = Factor.new(user.character).as_json
    expected = Response.new(6, data)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end

  test 'show wrong parameter' do
    user = User.create(number: 1, password: 'j', character_name: 'name')

    get :show, params: { token: 'MTpq' }

    body = JSON.parse(response.body)
    expected = Response.new(0)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end

  test 'show wrong authorization' do
    user = User.create(number: 1, password: 'j', character_name: 'name')

    get :show, params: { token: 'sda', name: 'name' }

    body = JSON.parse(response.body)
    expected = Response.new(2)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'show wrong character name' do
    user = User.create(number: 1, password: 'j', character_name: 'name')

    get :show, params: { token: 'MTpq', name: 'asdas' }

    body = JSON.parse(response.body)
    expected = Response.new(7)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
end
