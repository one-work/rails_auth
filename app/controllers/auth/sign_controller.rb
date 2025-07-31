module Auth
  class SignController < BaseController
    before_action :check_login, except: [:logout]
    skip_after_action :set_auth_token, only: [:logout]
    before_action :set_oauth_user, only: [:bind, :direct, :bind_create]
    before_action :set_confirmed_account, only: [:login], if: -> { params[:identity].present? }
    before_action :set_verify_token, only: [:password, :token]

    def code
      @verify_token = VerifyToken.build_with_identity(params[:identity])

      if @verify_token.send_out!
        render 'code', locals: { message: t('.sent') }
      else
        render 'code_token', locals: { message: @verity_token.error_text }, status: :bad_request
      end
    end

    def bind
    end

    def bind_create
      @oauth_user.can_login?(login_params)
    end

    def password
      if @verify_token
        render :password
      else
        render :password_wrong
      end
    end

    def join
      @verify_token = VerifyToken.find_by(uuid: params[:uuid])
      @account = Account.build_with_identity(@verify_token.identity)

      if @account.can_login_by_token?(login_params)
        login_by_account @account

        render_login
      else
        flash.now[:error] = @account.error_text.presence || @account.user.error_text
        render 'alert', status: :unauthorized
      end
    end

    def login
      if @account&.can_login_by_password?(params[:password])
        login_by_account @account

        render_login
      else
        if @account
          flash.now[:error] = @account.error_text.presence || @account.user.error_text
        else
          flash.now[:error] = '账号密码错误'
        end
        render 'alert', status: :unauthorized
      end
    end

    def token_login_new
    end

    def token_login
      @verify_token = VerifyToken.build_with_identity(params[:identity])

      if @verify_token.send_out!
        render 'token_login', locals: { message: t('.sent') }
      end
    end

    def token
      @account = @verify_token&.account
      if @account && @account&.user
        login_by_account @account
        render_login
      else
        flash.now[:error] = '你的账号还未注册'
        render 'alert', status: :unauthorized
      end
    end

    def logout
      Current.session&.destroy
      session.delete :auth_token
    end

    private
    def set_verify_token
      @verify_token = VerifyToken.valid.find_by(identity: params[:identity].strip, token: params[:token])
    end

    def set_confirmed_account
      @account = Account.where(identity: params[:identity].strip).confirmed.with_user.take
    end

    def set_oauth_user
      @oauth_user = OauthUser.find_by uid: params[:uid]
    end

    def password_params
      params.permit(:password)
    end

    def login_params
      q = params.permit(
        :name,
        :password,
        :password_confirmation,
        :invited_code,
        :uid,
        :device_id  # ios设备注册
      )

      if session[:return_to]
        r = URI.decode_www_form(URI(session[:return_to]).query.to_s).to_h
        q.merge! invited_code: r['invited_code'] if r.key?('invited_code')
      end

      if request.format.json?
        q.merge! source: 'api'
      else
        q.merge! source: 'web'
      end
      q
    end



    def check_login
      if current_user && !request.format.json?
        redirect_to RailsAuth.config.default_home_path
      end
    end

  end
end
