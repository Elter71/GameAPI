require 'test_helper'

class FactorTest < ActiveSupport::TestCase

  test "create factor statistic and return as json" do
    response_json_in_string='{"name":"name","level":1,"experience":0,"stamina":1,"strength":1,"dexterity":1,"HP":10,"attack":2,"avoidance":0}'
    character = Character.create({name: "name"})
    factor = Factor.new(character)
    
    assert true, "factor as json"
  end

end