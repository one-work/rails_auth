module Auth
  class Panel::AccountsController < Panel::BaseController
    before_action :set_account, only: [:show, :edit, :update, :destroy, :prune]

    def index
      q_params = {}
      q_params.merge! params.permit(:user_id, :identity, :type)

      @accounts = Account.includes(:user).default_where(q_params).order(id: :desc).page(params[:page])
    end

    def prune
      @account.class.transaction do
        @account.destroy!
        @account.oauth_users.map(&:destroy!)
      end
    end

    private
    def set_account
      @account = Account.find params[:id]
    end

    def account_permit_params
      [
        :user_id,
        :identity,
        :type,
        :confirmed,
        :primary
      ]
    end

  end
end
