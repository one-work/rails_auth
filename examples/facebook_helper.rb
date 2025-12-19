class FacebookHelper
  attr_reader :strategy

  def initialize
    @strategy = OmniAuth::Strategies::Facebook.new(nil, SETTING['f_key'], SETTING['f_secret'])
  end

  def info(acc: xx)
    access_token = 'xx'
  end

end


