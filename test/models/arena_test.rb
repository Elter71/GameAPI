require 'test_helper'

class ArenaTest < ActiveSupport::TestCase
  def setup
    @name_1 = 'name'
    @name_2 = 'last'
  end

  test 'create arena OK' do
    Character.create(name: @name_1)
    Character.create(name: @name_2)
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)

    assert arena.id, 'Arena create correct'
    assert arena.status == ArenaStatus::IN_PROGRESS, 'Status incorrect'
    assert arena.character_1_name == @name_1, 'character name 1'
    assert arena.character_2_name == @name_2, 'character name 2'
    assert arena.valid?, 'Error arena create validationls'
  end
  test 'arena character name incorrect' do
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)

    assert !arena.valid?, 'Error arena create validationls'
  end
  test 'arena character attack normal fight' do
    character = Character.create(name: @name_1)
    character.statistics.dexterity = 0
    character.statistics.save
    character = Character.create(name: @name_2)
    character.statistics.dexterity = 0
    character.statistics.save
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)
    attacker_1 = arena.get_attacker_character
    attack_result_1 = arena.attack(attacker_1.name)
    attacker_2 = arena.get_attacker_character
    attack_result_2 = arena.attack(attacker_2.name)


    assert attack_result_1, 'Attack result 1 is nil'
    assert attack_result_1.event_results.event.type == EventType::ATTACK, 'Wrong event type in attack_result_1'
    event_value = attack_result_1.event_results.event.value
    assert (event_value > 0 and event_value < 3), 'Wrong event value in attack_result_1'
    assert attack_result_1.event_results.result == Result::SUCCESSFUL, 'Wrong event result in attack_result_1'
    assert attacker_2.statistics.hp_subtract == event_value, 'Wrong hp_subtract on defenter_1'

    assert attack_result_2, 'Attack result 2 is nil'
    assert attack_result_2.event_results.event.type == EventType::ATTACK, 'Wrong event type in attack_result_2'
    event_value = attack_result_2.event_results.event.value
    assert (event_value > 0 && event_value < 3), 'Wrong event value in attack_result_2'
    assert attack_result_2.event_results.result == Result::SUCCESSFUL, 'Wrong event result in attack_result_2'
    assert attacker_1.statistics.hp_subtract == event_value, 'Wrong hp_subtract on defenter_2'

    assert attacker_1 != attacker_2, 'Error attacker 1 and attacker 2 is the same character'
    assert arena.valid?, 'Error arena create validationls'
  end

  test 'arena character attack death test' do
    character = Character.create(name: @name_1)
    character.statistics.dexterity = 0
    character.statistics.save
    character = Character.create(name: @name_2)
    character.statistics.dexterity = 0
    character.statistics.save
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)
    attacker_1 = arena.get_attacker_character
    attacker_1.statistics.strength = 100
    attack_result_1 = arena.attack(attacker_1.name)

    attacker_2 = arena.get_attacker_character
    attack_result_2 = arena.attack(attacker_2.name)

    assert attack_result_1, 'Attack result 1 is nil'
    assert attack_result_1.event_results.event.type == EventType::DEATH, 'Wrong event type in attack_result_1'
    value = attack_result_1.event_results.event.value
    assert (value <= 200 && value >= 100), 'Event value incorrenct'
    assert Character.find(attacker_1.name).statistics.experience == 100, 'Wrong experience from winner'
    assert Character.find(attacker_2.name).statistics.experience == 25, 'Wrong experience from defender'
    assert attack_result_1.attacker_name == attacker_1.name, 'Wrong attacker name in attack result'
    assert attack_result_1.defender_name == attacker_2.name, 'Wrong defender name in attack result'
    assert attack_result_1.event_results.result == Result::SUCCESSFUL, 'Wrong event result in attack_result_1'
    assert attack_result_2.nil?, "Attack result 2 isn't nil"
    assert arena.status == ArenaStatus::END_, 'Wrong arena status!'
    assert arena.winner_name == attacker_1.name, 'Wrong winner name'
    assert arena.valid?, 'Error arena create validationls'
  end

  test 'arena character attack success avoidance test' do
    character = Character.create(name: @name_1)
    character.statistics.dexterity = 100
    character.statistics.save
    character = Character.create(name: @name_2)
    character.statistics.dexterity = 100
    character.statistics.save
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)
    attacker_1 = arena.get_attacker_character
    attack_result_1 = arena.attack(attacker_1.name)

    assert attack_result_1, 'Attack result 1 is nil'
    assert attack_result_1.event_results.event.type == EventType::ATTACK, 'Wrong event type in attack_result_1'
    value = attack_result_1.event_results.event.value
    assert (value <= 2 && value >= 1), 'Event value incorrenct'
    assert attack_result_1.event_results.result == Result::UNSUCCESSFUL, 'Wrong event result in attack_result_1'
    assert arena.valid?, 'Error arena create validationls'
  end

  test 'arena character escape test' do
    character = Character.create(name: @name_1)
    character.statistics.dexterity = 100
    character.statistics.save
    character = Character.create(name: @name_2)
    character.statistics.dexterity = 100
    character.statistics.save
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)
    attacker_1 = arena.get_attacker_character
    attack_result_1 = arena.run(attacker_1.name)

    assert attack_result_1, 'Attack result 1 is nil'
    assert attack_result_1.event_results.event.type == EventType::RUN, 'Wrong event type in attack_result_1'
    assert attack_result_1.event_results.result == Result::SUCCESSFUL, 'Wrong event result in attack_result_1'
    assert arena.status == ArenaStatus::END_, 'Wrong arena status'
    assert Character.find(attacker_1.name).statistics.experience == 25, 'Wrong experience from runer'
    assert attack_result_1.attacker_name == attacker_1.name, 'Wrong attacker name in ArenaResult'
    assert arena.valid?, 'Error arena create validationls'
  end
  test 'aren wrong attacker' do
    character = Character.create(name: @name_1)
    character = Character.create(name: @name_2)
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)
    attacker_1 = arena.get_attacker_character
    attacker_1.name == @name_1 ? attack_result_1 = arena.attack(@name_2) : attack_result_1 = arena.attack(@name_1)


    assert attack_result_1.nil?, "Attack result 1 is't nil"
    assert arena.valid?, 'Error arena create validationls'
  end
  test 'aren wrong run' do
    character = Character.create(name: @name_1)
    character = Character.create(name: @name_2)
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)
    attacker_1 = arena.get_attacker_character
    attacker_1.name == @name_1 ? attack_result_1 = arena.run(@name_2) : attack_result_1 = arena.run(@name_1)


    assert attack_result_1.nil?, "Attack result 1 is't nil"
    assert arena.valid?, 'Error arena create validationls'
  end
  test 'aren wrong character name to attack' do
    character = Character.create(name: @name_1)
    character = Character.create(name: @name_2)
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)
    attack_result_1 = arena.attack("asdfgh")

    assert attack_result_1.nil?, "Attack result 1 is't nil"
    assert arena.valid?, 'Error arena create validationls'
  end
  test 'aren wrong character name to run' do
    character = Character.create(name: @name_1)
    character = Character.create(name: @name_2)
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)
    attack_result_1 = arena.run("asdfgh")

    assert attack_result_1.nil?, "Attack result 1 is't nil"
    assert arena.valid?, 'Error arena create validationls'
  end
  test 'arena last event attack' do
    character = Character.create(name: @name_1)
    character = Character.create(name: @name_2)
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)
    attacker_1 = arena.get_attacker_character
    event = arena.attack(attacker_1.name)


    assert event == arena.last_event, 'Last evnet incorrests'
    assert arena.valid?, 'Error arena create validationls'
  end

  test 'arena last event run' do
    character = Character.create(name: @name_1)
    character = Character.create(name: @name_2)
    arena = Arena.create(character_1_name: @name_1, character_2_name: @name_2)
    attacker_1 = arena.get_attacker_character
    event = arena.run(attacker_1.name)


    assert event == arena.last_event, 'Last evnet incorrests'
    assert arena.valid?, 'Error arena create validationls'
  end


end
