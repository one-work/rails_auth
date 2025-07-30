module Auth
  class UsersController < BaseController
    before_action :set_new_user, only: [:create]

    def create
      @verify_token = VerifyToken.valid.find_by(identity: params[:identity], token: params[:token])

      if @verify_token
        unless @user.save
          redirect_to({ action: 'new' }, alert: @user.errors.full_messages.join(', '))
        end
      else
        redirect_to({ action: 'new' }, alert: '验证码不正确或已过期！')
      end
    end
    private
    def set_new_user
      @user = User.new(user_params)
    end

    def user_params
      params.permit(
        :password,
        :password_confirmation
      )
    end

  end
end
