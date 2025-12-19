module Auth
  class Panel::UserTagsController < Panel::BaseController
    before_action :set_user_tag, only: [:show, :edit, :update, :destroy]
    before_action :set_new_user_tag, only: [:new, :create]

    def index
      q_params = {}
      q_params.merge! default_params

      @user_tags = UserTag.default_where(q_params).page(params[:page])
    end

    def show
      user_ids = @user_tag.user_taggeds.pluck(:user_id)
      @users = User.default_where(id: user_ids).order(id: :desc)
    end

    private
    def set_user_tag
      @user_tag = UserTag.find(params[:id])
    end

    def set_new_user_tag
      @user_tag = UserTag.new(user_tag_params)
    end

    def user_tag_params
      params.fetch(:user_tag, {}).permit(
        :name
      )
    end

  end
end
