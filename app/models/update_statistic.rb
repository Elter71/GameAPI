class UpdateStatistic
  def initialize(parameter)
    @update_type = parameter if check_is_update_type_and_is_not_nil(parameter)
  end

  private def check_is_update_type_and_is_not_nil(parameter)
    parameter.type && parameter.data if parameter.is_a?(UpdateType)
  end
end
