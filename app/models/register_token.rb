class RegisterToken
  def initialize
    catch_no_method_error_on_generated_token_and_set_date
  end

  private def catch_no_method_error_on_generated_token_and_set_date
    begin
      when_time_now_is_after_then_given_in_seconds(600)
    rescue NoMethodError
      generated_token_and_set_date
    end
  end

  def when_time_now_is_after_then_given_in_seconds(wait_time)
    generated_token_and_set_date if DateTime.now.strftime('%s') > @date.strftime('%s')+wait_time
  end

  def generated_token_and_set_date
    @token = rand(36**9).to_s(36)
    @date = DateTime.now
  end


  def token_is_correct?(token)
    token == @token
  end

  @@instance = RegisterToken.new

  def self.instance
    @@instance
  end

  private_class_method :new
end