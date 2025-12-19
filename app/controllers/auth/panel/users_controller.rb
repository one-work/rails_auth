module Auth
  class Panel::UsersController < Panel::BaseController
    before_action :set_user, only: [:show, :edit, :update, :edit_user_tags, :edit_role, :destroy]
    before_action :set_new_user, only: [:new, :create]

    def index
      q_params = {
        'created_at-desc': 2
      }
      q_params.merge! user_filter_params

      @users = User.with_attached_avatar.includes(:accounts, :roles, :oauth_users).default_where(q_params).page(params[:page])
    end

    def month
      q_params = {}
      x = Arel.sql("date_trunc('day', created_at, '#{Time.zone.tzinfo.identifier}')")
      r = User.where(q_params).group(x).order(x).count

      result = []
      r.each do |key, v|
        result << { year: key.in_time_zone.to_fs(:date), value: v }
      end

      render json: result
    end

    def new
      @user.accounts.build
    end

    def edit_user_tags
      @user_tags = UserTag.default_where(default_params).page(params[:page])
    end

    def edit_role
      @roles = @user.visible_roles
    end

    def mock
      @user = User.find_or_initialize_by(user_uuid: params[:account])

      if @user.persisted?
        login_as @user
        render :create
      else
        if @user.join(user_params)
          login_as @user
          render :create
        end
      end
    end

    private
    def set_user
      @user = User.find(params[:id])
    end

    def set_new_user
      @user = User.new(user_params)
    end

    def user_filter_params
      q = params.permit(
        :id,
        'name-like',
        'accounts.identity',
        'last_login_at-desc'
      )
      q.merge! super if defined? super
      q
    end

    def user_params
      params.fetch(:user, {}).permit(*user_permit_params)
    end

    def user_permit_params
      [
        :name,
        :avatar,
        :password,
        :disabled,
        user_tag_ids: [],
        role_whos_attributes: [:id, :role_id, :_destroy],
        accounts_attributes: {}
      ]
    end

  end
end
