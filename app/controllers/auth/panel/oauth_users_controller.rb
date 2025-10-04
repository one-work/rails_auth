module Auth
  class Panel::OauthUsersController < Panel::BaseController

    def index
      q_params = {}
      q_params.merge! params.permit(:identity, :uid, :unionid, :appid, :name, :user_id)

      @oauth_users = OauthUser.where.not(type: 'Auth::Account').includes(:user).default_where(q_params).order(id: :desc).page(params[:page])
    end

    def month
      q_params = {}
      x = Arel.sql("date_trunc('day', created_at, '#{Time.zone.tzinfo.identifier}')")
      r = OauthUser.where(q_params).group(x).order(x).count

      result = []
      r.each do |key, v|
        result << { year: key.in_time_zone.to_fs(:date), value: v }
      end

      render json: result
    end

    private
    def oauth_user_permit_params
      [
        :name,
        :remark
      ]
    end

  end
end
