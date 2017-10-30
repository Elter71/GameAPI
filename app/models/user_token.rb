module UserToken
  def self.generate_token(number, password)
    return Base64.encode64("#{number}:#{password}")
  end

  def self.decode_token_and_split(token)
    Base64.decode64(token).split(/\s*:\s*/)
  end
end