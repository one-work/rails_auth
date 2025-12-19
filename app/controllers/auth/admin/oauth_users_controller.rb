module Auth
  class Admin::OauthUsersController < Admin::BaseController
    before_action :set_oauth_user, only: [:show, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! appid: current_organ.apps.pluck(:appid) if defined?(current_organ) && current_organ.respond_to?(:apps)
      q_params.merge! params.permit(:user_id, :uid, :appid, :name)

      @oauth_users = OauthUser.includes(:app, :authorized_tokens).default_where(q_params).order(id: :desc).page(params[:page])
    end

    private
    def set_oauth_user
      @oauth_user = OauthUser.find(params[:id])
    end

  end
end
