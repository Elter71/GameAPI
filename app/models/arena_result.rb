class ArenaResult
  attr_reader :attacker_name, :defender_name, :event_results
  # @param [String] attacker_name
  # @param [String] defender_name
  # @param [EventResult] event_results
  def initialize(attacker_name, defender_name, event_results)
    @attacker_name = attacker_name
    @defender_name = defender_name
    @event_results = event_results
  end

end
