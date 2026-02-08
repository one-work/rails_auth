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
      if @user.update(params.permit(:password, :password_confirmation))
        render notice: "新密码已成功设置"
      else
        redirect_to({ action: 'edit', token: params[:token] }, alert: '请确认密码是否一致')
      end
    end

    private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to action: 'new', alert: 'Password reset link is invalid or has expired.'
    end

  end
end