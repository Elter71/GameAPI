class AICharacter
  def initialize(arena)
    @arena = arena
    @name = 'AI'
  end

  def change
    if @arena.get_attacker_character.name == @name && arena_status
      attack
    end
  end

  private def arena_status
    @arena.status == ArenaStatus::IN_PROGRESS
  end

  private def attack
    @arena.attack(@name)
  end

end