class EventResult
  attr_reader :event, :result
  # @param [Event] event
  # @param [Result] result
  def initialize(event, result)
    @event = event
    @result = result
  end

end
