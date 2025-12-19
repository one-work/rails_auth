module Auth
  module Model::OauthUser::AlipayUser
    extend ActiveSupport::Concern

    included do
      attribute :provider, :string, default: 'alipay'
      before_save :sync_user_info, if: -> { auth_code_changed? }
    end

    def save_info(oauth_params)
      self.access_token = oauth_params['access_token']
      self.auth_code = oauth_params['auth_code']
    end

    def sync_user_info
      get_access_token
      get_user_info
    end

    def get_auth_token
      result = Alipay::Service.open_auth_token_app(code: self.auth_code)
      result = JSON.parse result
      result = result['alipay_open_auth_token_app_response']
      if result
        self.update_columns app_auth_token: result['app_auth_token']
      end
      self.app_auth_token
    end

    def get_access_token
      result = Alipay::Service.system_oauth_token({}, { grant_type: 'authorization_code', code: self.auth_code })
      result = JSON.parse result
      result = result['alipay_system_oauth_token_response']
      if result
        self.access_token = result['access_token']
      end
      self.access_token
    end

    def get_user_info
      result = Alipay::Service.user_info_share({}, { auth_token: self.access_token })
      result = JSON.parse result
      result = result['alipay_user_info_share_response']
      if result
        _name = String.new(result['nick_name'].to_s, encoding: 'GBK').encode('UTF-8')
        self.avatar_url = String.new(result['avatar'].to_s, encoding: 'GBK').encode('UTF-8')
        self.name = _name
        self.user.name = _name
        self.user.save
      end
      result
    end

  end
end
