require 'test_helper'

class AICharacterTest < ActiveSupport::TestCase
  test 'AICharacter test' do
    c = Character.create(name: 'name')
    c.statistics.dexterity=0
    c.statistics.save
    c = Character.create(name: 'AI')
    c.statistics.dexterity=0
    c.statistics.save
    arena = Arena.create(character_1_name: 'name', character_2_name: 'AI')
    if arena.last_event.nil?
      arena.attack('name')
    end
    attacker = arena.get_attacker_character
    last_event = arena.last_event
    event_value = last_event.event_results.event.value
    assert attacker.statistics.hp_subtract > 0 , 'Wrong hp substract'
  end

end