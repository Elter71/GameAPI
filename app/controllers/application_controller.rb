class ApplicationController < ActionController::API
  def initialize
    @check_params = CheckParams.instance
  end
  protected def find_user_by_token(token)
    begin
      User.find_by_id_from_token(token)
    rescue NoMethodError
      nil
    end
  end
end
