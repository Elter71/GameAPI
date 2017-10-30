require 'test_helper'

class StatisticTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'create new statistic' do
    name = 'name'
    statistic = Statistic.create_new(name)

    assert statistic.stamina == 1
    assert statistic.strength == 1
    assert statistic.dexterity == 1
    assert statistic.level == 1
    assert statistic.experience.zero?
    assert statistic.character_name == name
  end

  test 'update character statistic' do
    name = 'name'
    statistic = Statistic.create_new(name)
    update_para = { type: 'statistics', data: { stamina: 1, strength: 1 } }
    update = UpdateType.new(update_para)
    statistic.update(update)

    assert statistic.stamina == 2, 'stamina'
    assert statistic.strength == 2, 'strength'
    assert statistic.dexterity == 1, 'dexterity'
  end
  test 'update character experience' do
    Level.create(level: 1, experience_to_next: 100)
    name = 'name'
    statistic = Statistic.create_new(name)
    update_para = { type: 'experience', data: { experience: 100 } }
    update = UpdateType.new(update_para)
    statistic.update(update)

    assert statistic.experience == 100, 'experience'
  end
end
