module WechatClient
  extend self

  def oauth_client(scope = [])
    return @oauth_client if defined?(@oauth_client)
    @oauth_client = OmniAuth::Strategies::Wechat.new(
      nil, # App - nil seems to be ok?!
      RailsAuth.config.wechat_app.appid,
      RailsAuth.config.wechat_app.secret,
      scope: scope
    )
  end

  def client
    @client ||= OAuth2::AccessToken.new self.class.oauth_client, access_token
  end

end
