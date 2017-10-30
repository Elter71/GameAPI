class HomeController < ApplicationController
  def index
    render json: RegisterToken.instance.as_json
  end
end
