module Auth
  class UsersController < BaseController
    before_action :set_new_user, only: [:create]

    def create
      @verify_token = VerifyToken.valid.find_by(identity: params[:identity], token: params[:token])

      if @verify_token
        unless @user.save
          render 'alert_message', locals: { message: @user.errors.full_messages.join(', ') }
        end
      else
        render 'alert_message', locals: { message: '验证码不正确或已过期！' }
      end
    end

    private
    def set_new_user
      @user = User.new(user_params)
    end

    def user_params
      _p = params.permit(
        :password,
        :password_confirmation
      )
      _p.merge! accounts_attributes: [
        {
          identity: params[:identity],
          confirmed: true
        }
      ]
    end

  end
end
