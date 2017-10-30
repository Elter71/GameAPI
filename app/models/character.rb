class Character < ApplicationRecord
  self.primary_key = 'name'

  before_create :create_statistic
  validates_uniqueness_of :name
  attr_reader :attacker

  def statistics
    @statistic ? @statistic : @statistic = Statistic.find(name)
  end

  def update(parameter)
    statistics.update(parameter)
  end

  private def create_statistic
    Statistic.create_new(name)
    @attacker = false
  end

  def set_attacker
    @attacker = true
  end

  def reset_attacker_mask
    @attacker = false
  end

  # @param [Character] character
  # @return [EventResult]
  def attack(character)
    result = character.repelling_attack(statistics.attack)
    reset_attacker_mask
    character.set_attacker
    result
  end

  # @param [Int] attack
  # @return [EventResult]
  def repelling_attack(attack) # #DEF FUNCTION
    event = Event.new(EventType::ATTACK, attack)
    avoidance = Random.new.rand(1..100)
    if statistics.avoidance >= avoidance
      EventResult.new(event, Result::UNSUCCESSFUL)
    else
      statistics.hp_subtract += attack
      EventResult.new(event, Result::SUCCESSFUL)
    end
  end

  def escape
    reset_attacker_mask
    event = Event.new(EventType::RUN,0)
    EventResult.new(event,Result::SUCCESSFUL)
  end

  # @return [Boolean]
  def death?
    statistics.hp <= 0
  end
end
