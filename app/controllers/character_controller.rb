class CharacterController < ApplicationController

  def update
    if (@check_params.check_is_params_exist(params, :token, :type, :data))
      check_update_type(params)
    else
      render json: Response.new(0).as_json
    end
  end

  private def check_update_type(params)
    update_type = UpdateType.new(params)
    if (update_type.type)
      user = find_user_by_token(params[:token])
      update_user_character(user, update_type)
    else
      render json: Response.new(5).as_json
    end
  end

  private def update_user_character(user, update_type)
    if (user)
      user.character.update(update_type)
      render json: Response.new(99).as_json
    else
      render json: Response.new(2).as_json
    end

  end

  def show
    if (@check_params.check_is_params_exist(params, :token, :name))
      user = find_user_by_token(params[:token])
      show_character(user, params[:name])
    else
      render json: Response.new(0).as_json
    end
  end

  private def show_character(user, name)
    if user
      check_character_name_correctly(user,name)
    else
      render json: Response.new(2).as_json
    end
  end

  private def check_character_name_correctly(user, character_name)
    if user.character_name_correctly?(character_name)
      create_factor(character_name)
    else
      render json: Response.new(7).as_json
    end
  end
  private def create_factor(character_name)
    factor = Factor.new(character_name)
    render json: Response.new(6, factor.as_json)
  end

end
