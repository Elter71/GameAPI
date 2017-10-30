require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  def setup
    @character_para = {name: "name"}
    @character = Character.create(@character_para)
  end

  test "character create" do
    assert @character.name == "name"
    assert @character.statistics
  end

  test "character update statistics of character" do
    update_para = {type: "statistics", data: {stamina: 1, strength: 1}}
    update = UpdateType.new(update_para)
    @character.update(update)

    assert @character.statistics.stamina == 2, "stamina"
    assert @character.statistics.strength == 2, "strength"
    assert @character.statistics.dexterity == 1, "dexterity"
  end
  test "character update experience " do
    Level.create({level: 1, experience_to_next: 100})
    update_para = {type: "experience", data: {experience: 100}}
    update = UpdateType.new(update_para)
    @character.update(update)

    assert @character.statistics.experience == 100, "experience"
  end
end
