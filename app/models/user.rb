class User < ApplicationRecord
  require 'digest/sha2'
  require 'base64'
  self.primary_key = 'number'
  before_create :save_password, :save_token, :create_character
  validates_uniqueness_of :number, :character_name

  def self.find_by_id_from_token(token_)
    number_, password_ = UserToken.decode_token_and_split(token_)
    User.find_by(number: number_).token_is_correct?(token_)
  end

  def token_is_correct?(token_)
    return self if hash_password_in_token(token_) == token
  end

  def character
    Character.find(character_name)
  end

  private def hash_password_in_token(token)
    number_, password_ = UserToken.decode_token_and_split(token)
    UserToken.generate_token(number_, Digest::SHA2.new(256).hexdigest(password_))
  end

  def self.delete(token)
    number_, password_ = UserToken.decode_token_and_split(token)
    destroy(number_)
  end

  def change_password(password_)
    self.password= hash_password(password_)
    self.save
  end

  private def save_password
    self.password= hash_password(password)
  end

  private def hash_password(password_)
    Digest::SHA2.new(256).hexdigest(password_)
  end

  private def create_character
    Character.create({name: character_name})
  end

  private def save_token
    self.token= UserToken.generate_token(number, password)
  end

  def character_name_correctly?(name)
    character_name == name
  end

end
