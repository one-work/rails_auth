module Auth
  class OauthController < ApplicationController
    skip_forgery_protection

    def alipay
      result = Alipay::Service.open_auth_token_app(code: params[:app_auth_code])
      result = JSON.parse result
      result = result['alipay_open_auth_token_app_response']

      if result['code'] == '10000'
        @oauth_user = OauthUser.find_or_initialize_by(type: 'AlipayUser', uid: result['user_id'])
        @oauth_user.assign_attributes provider: 'alipay', app_auth_token: result['app_auth_token'], app_refresh_token: result['app_refresh_token']
        @oauth_user.user = User.first
        @oauth_user.save
      end
      #result = Alipay::Service.system_oauth_token({}, { grant_type: 'authorization_code', code: params[:app_auth_code] })
      #
      # app_refresh_token
    end

    def github
      @github_app = GithubApp.find_by(state: params[:state])
      @github_app.generate_github_user(params[:code], user_id: current_user.id)

      redirect_to controller: 'auth/board/oauth_users'
    end

    def apple
      payload = AppleUser.verify!(params[:identity_token], audience: 'com.xcprinter.xcprinter')
      logger.debug "----------#{payload}"

      user = AppleUser.find_or_initialize_by(identity: payload['sub'])
      if user.new_record?
        user.email = params[:email].presence || payload['email']
        user.name = [params[:given_name], params[:family_name]].compact.join(" ")
      end
      user.save!
    end

  end
end
