class Statistic < ApplicationRecord
  self.primary_key = 'character_name'
  attr_accessor :attack_subtract, :hp_subtract, :avoidance_subtract
  after_find :create_subtracts

  def self.create_new(name)
    Statistic.create(character_name: name, stamina: 1, strength: 1, dexterity: 1, level: 1, experience: 0)
  end

  def create_subtracts
    @hp_subtract = 0
    @attack_subtract = 0
    @avoidance_subtract = 0
  end

  public def update(parameter)
    send("update_#{parameter.type}", parameter.data)
    save
  end

  def attack
    value = Random.new.rand(1..2)
    (value * strength) - @attack_subtract
  end

  def hp
    (10 * stamina) - @hp_subtract
  end

  def avoidance
    dexterity - @avoidance_subtract
  end

  private def update_statistics(data)
    self.stamina += data[:stamina] if data[:stamina]
    self.strength += data[:strength] if data[:strength]
    self.dexterity += data[:dexterity] if data[:dexterity]
  end
  private def update_experience(data)
    self.level += 1 if next_level?
    self.experience += data[:experience]
  end

  private def next_level?
    begin
      level < Level.last.level && experience > Level.find(level).experience_to_next
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
end
