module Auth
  class PasswordController < BaseController



    def edit
      reset_token = AuthorizedToken.find(params[:token])

      if reset_token
        if reset_token.verify_token?
          @user = reset_token.user
          render :edit and return
        else
          @error_message = 'Reset Token 已失效, 请重新申请'
          render :edit_error and return
        end
      else
        @error_message = '重置Token无效'
        render :edit_error
      end
    end

    def reset
      if params[:identity].include?('@')
        @user = User.find_by(email: params[:identity])
      else
        @user = User.find_by(mobile: params[:identity])
      end

      unless @user
        render json: { code: 40001, message: '该手机号未注册' }, status: :bad_request and return
      end

      @token = @user.verify_tokens.valid.find_by(token: params[:token])
      if @token
        @user.assign_attributes user_params
        if @user.save
          render :create and return
        else
          process_errors(@user)
        end
      else
        render json: { message: '验证码错误' }, status: :bad_request
      end
    end

    def update
      reset_token = AuthorizedToken.find(params[:token])
      @user = reset_token.user
      @account = reset_token.account

      User.transaction do
        reset_token.destroy!
        @user.update!(password_params)
      end
    end

    private
    def password_params
      params.permit(
        :password,
        :password_confirmation
      )
    end

  end
end
