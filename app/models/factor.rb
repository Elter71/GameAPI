require 'json'
class Factor
  attr_reader :hp_factor,:attack_factor,:avoidance_factor
  def initialize(character_name)
    @character = Character.find_by(name: character_name)
    @hp_factor = 10
    @attack_factor = 2
    @avoidance_factor = 100
  end

  def as_json
    result = Hash.new
    result[:name] = @character.name
    result[:level] = @character.statistics.level
    result[:experience] = @character.statistics.experience
    result[:stamina] = @character.statistics.stamina
    result[:strength] = @character.statistics.strength
    result[:dexterity] = @character.statistics.dexterity
    result[:HP] = @hp_factor*result[:stamina]
    result[:attack] = @attack_factor*result[:strength]
    result[:avoidance] = result[:dexterity]/@avoidance_factor

    result.to_json
  end

end