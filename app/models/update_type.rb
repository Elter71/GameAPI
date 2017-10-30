class UpdateType
  attr_reader :type, :data

  def initialize(params)
    check(params)
  end

  private def check(params_)
    @type = params_[:type]
    case type
      when "statistics"
        params = [:stamina, :strength, :dexterity]
      when "experience"
        params = [:experience]
      else
        return @type = @data = nil
    end
    @data = parameter_exist_in_table(params_[:data], params)
  end

  private def parameter_exist_in_table(table, params)
    result = Hash.new
    params.each {|index| result[index] = table[index].to_i if table.key?(index)}
    result
  end

end