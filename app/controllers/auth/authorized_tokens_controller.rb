module Auth
  class AuthorizedTokensController < BaseController
    skip_before_action :require_user, only: [:new, :create]
    rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to '/login', alert: "Try again later." }

    def new
    end

    def create
      user = User.authenticate_by(params.permit(:mobile_number, :password))
      if user
        start_new_session_for user
        redirect_to after_authentication_url
      else
        redirect_to('/login', alert: '账号密码错误！')
      end
    end

    def destroy
      terminate_session
      redirect_to '/login'
    end

    private
    def set_xx

    end

  end
end
