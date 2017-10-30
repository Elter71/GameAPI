class Arena < ApplicationRecord
  before_create :set_arena_status
  validate :check_characters_exist, on: :create
  after_create :draw_character_attacker
  attr_reader :last_event

  # def self.create(character_1_name,character_2_name,ai=nil)
  #   super(character_1_name: character_1_name,character_2_name: character_2_name)
  # end

  private def check_characters_exist
    @character_1 = Character.find(character_1_name)
    @character_2 = Character.find(character_2_name)
    @last_event = nil
  rescue ActiveRecord::RecordNotFound
    errors.add(:id, "Characters don't exist")
  end


  # @return [ArenaStatus]
  private def set_arena_status
    self.status = ArenaStatus::START
  end

  private def draw_character_attacker
    create_ai
    self.status = ArenaStatus::IN_PROGRESS
    random = Random.rand(1..2)
    random == 1 ? @character_1.set_attacker : @character_2.set_attacker
    ai_change
  end
  private def create_ai
    if character_2_name == "AI"
      @ai = AICharacter.new(self)
    end
  end

  private def ai_change
    @ai.change if @ai
  end

  # @param [String] character_name
  def attack(character_name)
    if character_name_corrected?(character_name) && status_in_progress?
      character_attacker = attacker_character(character_name)
      check_order_attacker(character_attacker)
    end
  end

  # @param [String] character_name
  private def character_name_corrected?(character_name)
    (character_name == character_1_name) || (character_name == character_2_name)
  end

  private def status_in_progress?
    status == ArenaStatus::IN_PROGRESS
  end
  # @param [String] character_name
  # @return [Character]
  private def attacker_character(character_name)
    (character_name == character_1_name) ? @character_1 : @character_2
  end


  # @param [Character] character
  # @return [ArenaResult]
  private def check_order_attacker(character)
    attack_character(character) if character.attacker
  end

  # @param [Character] character_attacker
  # @return [ArenaResult]
  private def attack_character(character_attacker)
    defence_character = defence_character(character_attacker)
    event_result = character_attacker.attack(defence_character)
    if defence_character.death?
      add_experience(character_attacker.name, defence_character.name)
      set_end_status_and_winner(character_attacker.name)

      event = Event.generate_death_event(event_result.event)
      event_result = EventResult.new(event, Result::SUCCESSFUL)
    end
    ai_change
    @last_event = ArenaResult.new(character_attacker.name, defence_character.name, event_result)
  end
  # @param [Character] character_attacker
  # @return [Character]
  private def defence_character(character_attacker)
    (character_attacker.name == character_1_name) ? @character_2 : @character_1
  end

  # @param [String] character_name
  private def set_end_status_and_winner(character_name)
    self.status = ArenaStatus::END_
    self.winner_name = character_name
  end
  # @param [String] winner_name
  # @param [String] defender_name
  private def add_experience(winner_name, defender_name)
    add_experience_to_character(winner_name, 100)
    add_experience_to_character(defender_name, 25)

  end
  # @return [Character]
  def get_attacker_character
    @character_1.attacker ? @character_1 : @character_2
  end

  # @param [String] character_name
  # @return [ArenaResult]
  def run(character_name)
    if character_name_corrected?(character_name) && status_in_progress?
      check_escape_character(attacker_character(character_name))
    end
  end

  # @param [String] escape_character
  # @return [ArenaResult]
  private def check_escape_character(escape_character)
    if check_order_attacker(escape_character)
      winner_name = defence_character(escape_character).name
      set_end_status_and_winner(winner_name)
      add_experience(winner_name, escape_character.name)
      event = escape_character.escape
      @last_event = ArenaResult.new(escape_character.name, winner_name, event)
      return @last_event
    end
    nil
  end

  # @param [String] character_name
  # @param [Int] experience
  # @return [UpdateType]
  private def add_experience_to_character(name, experience)
    update_para = {type: 'experience', data: {experience: experience}}
    update = UpdateType.new(update_para)
    Character.find(name).update(update)
    update
  end
  # def add_ai(ai)
  #   @ai = ai
  # end

end
