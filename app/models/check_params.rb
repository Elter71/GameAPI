class CheckParams

  def check_is_params_exist(params, *args)
    exist = true
    args.each {|index| exist = false  unless params.key?(index)}
    return exist
  end


  @@instance = CheckParams.new

  def self.instance
    @@instance
  end

  private_class_method :new
end