module Auth
  class Board::AccountsController < Board::BaseController
    before_action :set_account, only: [:edit, :update, :token, :confirm, :select, :destroy]

    def index
      @accounts = current_user.accounts.order(id: :asc)
    end

    def new
      @account = Account.new
    end

    def create
      set_new_account
      @account.assign_attributes account_params

      if @account.save
        @verify_token = @account.verify_token
        @verify_token.send_out
      else
        render :edit, locals: { model: @account }, status: :unprocessable_entity
      end
    end

    def token
      @verify_token = @account.verify_token
      @verify_token.send_out
    end

    def confirm
      @token = @account.verify_tokens.valid.find_by(token: params[:token])
      if @token
        @account.confirmed = true
      else
        @account.errors.add :base, '验证码错误，请核对'
      end

      if @token && @account.save
        flash[:alert] = 'token 验证成功'
      else
        render 'confirm', locals: { model: @account }, status: :unprocessable_entity
      end
    end

    def select
      @Current.session.update identity: @account.identity
    end

    private
    def set_account
      @account = current_user.accounts.find(params[:id])
    end

    def set_new_account
      if params[:identity].to_s.include?('@')
        @account = current_user.accounts.find_or_create_by(identity: account_params[:identity], type: 'Auth::EmailAccount')
      else
        @account = current_user.accounts.find_or_create_by(identity: account_params[:identity], type: 'Auth::MobileAccount')
      end
    end

    def account_params
      params.require(:account).permit(
        :identity,
        :confirmed
      )
    end

  end
end
