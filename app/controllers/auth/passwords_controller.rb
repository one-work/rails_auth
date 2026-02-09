module Auth
  class PasswordsController < BaseController
    before_action :set_user_by_token, only: [:edit, :update]

    def create
      @verify_token = VerifyToken.valid.find_by(identity: params[:identity], token: params[:token])

      if @verify_token
        @user = @verify_token.user
        if @user
        else
          render 'alert_message', status: :unauthorized, locals: { message: '请确认账号是否正确或是否注册!' }
        end
      else
        render 'alert_message', status: :unauthorized, locals: { message: '验证码错误!' }
      end
    end

    def update
      @user.assign_attributes password_params

      if @user.save!
        render 'alert_message', status: :unauthorized, locals: { message: '新密码已成功设置!' }
      else
        render 'alert_message', status: :unauthorized, locals: { message: '请确认密码是否一致!' }
      end
    end

    private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to action: 'new', alert: 'Password reset link is invalid or has expired.'
    end

    def password_params
      params.permit(
        :password,
        :password_confirmation
      )
    end

  end
end