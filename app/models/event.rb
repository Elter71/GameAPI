class Event
  attr_reader :type, :value
  # @param [EventType] type
  # @param [Int] value
  def initialize(type, value)
    @type = type
    @value = value
  end

  def self.generate_death_event(event)
    Event.new(EventType::DEATH, event.value)
  end

end
