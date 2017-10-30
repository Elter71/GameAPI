require 'test_helper'

class ArenaControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @character_para = {name: 'monster'}
    @monster = Character.create(@character_para)
    @user = User.create(number: 1, password: 'j', character_name: 'name')
  end


  test 'POST arena/find fight Ok' do
    Character.create(name: "AI")
    post :find, params: {token: 'MTpq', name: 'name'}
    body = JSON.parse(response.body)
    expected = Response.new(99)


    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    assert body["data"]["arena_id"], 'Empty arena_id'
    assert body["data"]["attacker_name"], 'Empty attacker_name'

    ArenaArray.instance.delete_arena(body["data"]["arena_id"])
  end

  test 'POST arena/find fight wrong params' do
    post :find, params: {name: 'name'}

    body = JSON.parse(response.body)
    expected = Response.new(0)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'POST arena/find fight wrong authorization' do
    post :find, params: {token: 'ashjdlkj', name: 'name'}

    body = JSON.parse(response.body)
    expected = Response.new(2)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test "POST arena/find fight wrong character name (character doesn't belong to user)" do
    post :find, params: {token: 'MTpq', name: 'monster'}

    body = JSON.parse(response.body)
    expected = Response.new(7)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end

  test 'POST arena/attack Ok' do
    create_arena
    check_attacker_character('name')
    post :attack, params: {token: 'MTpq', name: 'name', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(99)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    assert body["data"], 'Empty arena response'
    ArenaArray.instance.delete_arena(@arena.id)
  end

  private def create_arena
    @arena = Arena.create(character_1_name: 'name', character_2_name: 'monster')
    ArenaArray.instance.add(@arena)
  end

  private def check_attacker_character(name)
    attacker = ArenaArray.instance.get_by_id(@arena.id).get_attacker_character
    unless attacker.name == name
      ArenaArray.instance.get_by_id(@arena.id).attack(attacker.name)
    end
  end


  test 'POST arena/attack wrong order attacker' do
    create_arena
    check_attacker_character('monster')
    post :attack, params: {token: 'MTpq', name: 'name', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(9)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    ArenaArray.instance.delete_arena(@arena.id)
  end


  test 'POST arena/attack wrong params' do
    create_arena
    post :attack, params: {name: 'name', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(0)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'POST arena/attack wrong authorization' do
    create_arena
    post :attack, params: {token: 'ashjdlkj', name: 'name', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(2)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test "POST arena/attack wrong character name (character doesn't belong to user)" do
    create_arena
    post :attack, params: {token: 'MTpq', name: 'monster', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(7)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'POST arena/attack Wrong arena id' do
    create_arena
    post :attack, params: {token: 'MTpq', name: 'name', arena_id: 123}

    body = JSON.parse(response.body)
    expected = Response.new(8)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end

  test 'POST arena/escape Ok' do
    create_arena
    check_attacker_character('name')
    post :escape, params: {token: 'MTpq', name: 'name', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(99)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    assert body["data"], 'Empty arena response'
    ArenaArray.instance.delete_arena(@arena.id)
  end

  test 'POST arena/escape wrong order attacker' do
    create_arena
    check_attacker_character('monster')
    post :escape, params: {token: 'MTpq', name: 'name', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(9)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    ArenaArray.instance.delete_arena(@arena.id)
  end

  test 'POST arena/escape wrong params' do
    create_arena
    post :escape, params: {name: 'name', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(0)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'POST arena/escape wrong authorization' do
    create_arena
    post :escape, params: {token: 'ashjdlkj', name: 'name', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(2)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test "POST arena/escape wrong character name (character doesn't belong to user)" do
    create_arena
    post :escape, params: {token: 'MTpq', name: 'monster', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(7)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'POST arena/escape Wrong arena id' do
    create_arena
    post :escape, params: {token: 'MTpq', name: 'name', arena_id: 1546}

    body = JSON.parse(response.body)
    expected = Response.new(8)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end

  test 'POST arena/last nil last event' do
    create_arena
    post :last, params: {token: 'MTpq', name: 'name', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(99)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    assert body["data"].nil?, "Data isn't nil"
  end
  test 'POST arena/last OK' do
    create_arena
    arena = ArenaArray.instance.get_by_id(@arena.id)
    name = arena.get_attacker_character.name
    arena.attack(name)

    post :last, params: {token: 'MTpq', name: 'name', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(99)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
    assert body["data"], "Data isn't nil"
  end
  test 'POST arena/last wrong token' do
    create_arena
    post :last, params: {token: 'Mtpqsadf', name: 'name', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(2)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'POST arena/last wrong user name' do
    create_arena
    post :last, params: {token: 'MTpq', name: 'sdfghj', arena_id: @arena.id}

    body = JSON.parse(response.body)
    expected = Response.new(7)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end
  test 'POST arena/last wrong arena id' do
    create_arena
    post :last, params: {token: 'MTpq', name: 'name', arena_id: 12345}

    body = JSON.parse(response.body)
    expected = Response.new(8)

    assert expected.same?(body), "Response isn't as expected. Response: #{body.as_json}"
  end

end
