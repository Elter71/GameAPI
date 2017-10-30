class ArenaArray
  def initialize
    @arena = []
  end

  # @param [Arena] arena
  def add(arena)
    unless get_by_id(arena.id)
      @arena.push(arena)
    end
  end

  # @param [Int] arena_id
  # @return [Arena]
  def get_by_id(arena_id)
    unless @arena.empty?
      arena_in_array(arena_id)
      @result
    end
  end
  private def arena_in_array(arena_id)
    @arena.each do |element|
      (element.id == Integer(arena_id)) ? @result = element : @result = nil
    end
  end
  def delete_arena(arena_id)
    arena_in_array(arena_id)
    @arena.delete(@result)
  end

  @@instance = ArenaArray.new

  def self.instance
    @@instance
  end

  private_class_method :new
end
