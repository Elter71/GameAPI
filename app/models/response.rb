class Response
  def initialize(type,data = nil)
    @type = type
    @data = data
    case type
      when 0
        @message = 'Wrong params'
      when 1
        @message = 'Wrong token'
      when 2
        @message = 'Wrong authorization'
      when 3
        @message = 'User already exist'
      when 4
        @message = 'Character name already used'
      when 5
        @message = 'Wrong statistics type or data'
      when 6
        @message = 'Character statistic'
      when 7
        @message = 'Wrong character name'
      when 8
        @message = 'Wrong arena id'
      when 9
        @message = 'Wrong order attacker'
      when 99
        @message = 'OK'
      else
        @message = 'Not set message'
    end
  end

  def same?(parma)
    is_same = false
    is_same = true if parma["type"] == @type || parma["message"] == @message && parma["data"] == @data
    is_same
  end

end