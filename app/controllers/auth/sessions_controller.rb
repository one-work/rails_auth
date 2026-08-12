module Auth
  class SessionsController < BaseController
    before_action :set_account, only: [:create, :password_create, :token_create]
    before_action :require_user, only: [:destroy]
    rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to '/login', alert: "Try again later." }

    def create
      if @account
        if @account.user&.support_password_login?
          render 'password_new'
        else
          render 'token_new'
        end
      else
        render 'token_new'
      end
    end

    def password_create
      if @account&.can_login_by_password?(params[:password])
        start_new_session_for @account
        render_login(@account)
      else
        if @account
          message = @account.error_text.presence || @account.user.error_text
        else
          message = '账号密码错误'
        end
        render 'alert_message', status: :unauthorized, locals: { message: message }
      end
    end

    def token_create
      @verify_token = VerifyToken.valid.find_by(identity: params[:identity], token: params[:token])
      if @verify_token
        @account = @verify_token.oauth_user || @verify_token.create_oauth_user(confirmed: true)
        render locals: { user: @account.user }
      else
        render 'alert_message', status: :unauthorized, locals: { message: '验证码错误！' }
      end
    end

    def destroy
      terminate_session
    end

    private
    def set_account
      @account = OauthUser.confirmed.find_by identity: params[:identity]
    end

  end
end
