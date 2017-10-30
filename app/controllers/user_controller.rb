class UserController < ApplicationController
  def new
    if @check_params.check_is_params_exist(params, :number, :password, :character_name, :token)
      create_new_user(params.permit(:number, :password, :character_name, :token))
    else
      render json: Response.new(0).as_json
    end
  end

  private def create_new_user(params_)
    if RegisterToken.instance.token_is_correct?(params_[:token])
      user_validate(User.create(params_))
    else
      render json: Response.new(1).as_json
    end
  end
  private def user_validate(user)
    if user.valid?
      render json: Response.new(99).as_json
    else
      user_error_selection(user.errors[:number])
    end
  end
  private def user_error_selection(error)
    if error.blank?
      render json: Response.new(4).as_json
    else
      render json: Response.new(3).as_json
    end
  end

  def login
    if @check_params.check_is_params_exist(params, :token)
      user = find_user_by_token(params[:token])
      render_response_dependent_from_user(user)
    else
      render json: Response.new(0).as_json
    end
  end

  private def render_response_dependent_from_user(user)
    if user
      render json: Response.new(99).as_json
    else
      render json: Response.new(2).as_json
    end
  end

  def delete
    if @check_params.check_is_params_exist(params, :token)
      user = find_user_by_token(params[:token])
      delete_user(params[:token], user)
    else
      render json: Response.new(0).as_json
    end
  end

  private def delete_user(token, user)
    if user
      User.delete(token)
      render json: Response.new(99).as_json
    else
      render json: Response.new(2).as_json
    end
  end

  def update
    if @check_params.check_is_params_exist(params, :token, :password)
      user = find_user_by_token(params[:token])
      change_password_user_if_exist(params[:password], user)
    else
      render json: Response.new(0).as_json
    end
  end

  private def change_password_user_if_exist(password_, user)
    if user
      user.change_password(password_)
      render json: Response.new(99).as_json
    else
      render json: Response.new(2).as_json
    end
  end
end
