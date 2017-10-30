class ArenaController < ApplicationController
  def find
    if @check_params.check_is_params_exist(params, :token, :name)
      user = find_user_by_token(params[:token])
      create_arena(user, params[:name])
    else
      render json: Response.new(0).as_json
    end
  end

  private def create_arena(user, character_name)
    if check_params_correctness(user, character_name) == true
      arena = Arena.create(character_1_name: character_name, character_2_name: 'AI')
      ArenaArray.instance.add(arena)

      render json: Response.new(99, arena_id: arena.id, attacker_name: arena.get_attacker_character.name)
    end
  end

  private def check_params_correctness(user, character_name)
    check_character_name_correctness(user, character_name) if check_token_correctness(user) == true
  end

  private def check_token_correctness(user)
    if user
      true
    else
      render json: Response.new(2).as_json
    end
  end
  private def check_character_name_correctness(user, character_name)
    if user.character_name_correctly?(character_name)
      true
    else
      render json: Response.new(7).as_json
    end
  end

  def attack
    if @check_params.check_is_params_exist(params, :token, :name, :arena_id)
      user = find_user_by_token(params[:token])
      attack_character(user, params[:name], params[:arena_id])
    else
      render json: Response.new(0).as_json
    end
  end

  private def attack_character(user, character_name, arena_id)
    if check_arena_id_correctness(arena_id) == true && check_params_correctness(user, character_name) == true
      result = @arena.attack(character_name)
      with_response_form_result_attack(result)
    end
  end
  private def check_arena_id_correctness(arena_id)
    @arena = ArenaArray.instance.get_by_id(arena_id)
    if !@arena.nil?
      true
    else
      render json: Response.new(8).as_json
    end
  end

  private def with_response_form_result_attack(attack_result)
    if attack_result
      render json: Response.new(99, attack_result.as_json).as_json
    else
      render json: Response.new(9).as_json
    end
  end

  def escape
    if @check_params.check_is_params_exist(params, :token, :name, :arena_id)
      user = find_user_by_token(params[:token])
      escape_character(user, params[:name], params[:arena_id])
    else
      render json: Response.new(0).as_json
    end
  end

  private def escape_character(user, character_name, arena_id)
    if check_arena_id_correctness(arena_id) == true && check_params_correctness(user, character_name) == true
      result = @arena.run(character_name)
      with_response_form_result_attack(result)
    end
  end

  def last
    if @check_params.check_is_params_exist(params, :token, :name, :arena_id)
      user = find_user_by_token(params[:token])
      arena_last_event(user, params[:name], params[:arena_id])
    else
      render josn: Response.new(0).as_json
    end
  end

  private def arena_last_event(user, name, arena_id)
    if check_arena_id_correctness(arena_id) == true && check_params_correctness(user, name) == true
      render json: Response.new(99, @arena.last_event).as_json
    end
  end
end
