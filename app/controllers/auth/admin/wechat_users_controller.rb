module Auth
  class Admin::WechatUsersController < Admin::BaseController
    before_action :set_oauth_user, only: [:show, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! appid: current_organ.wechat_apps.pluck(:appid) if defined?(current_organ) && current_organ
      q_params.merge! params.permit(:user_id, :uid, :appid, :name)

      @oauth_users = OauthUser.default_where(q_params).order(id: :desc).page(params[:page])
    end

    private
    def set_oauth_user
      @oauth_user = OauthUser.find(params[:id])
    end

  end
end
