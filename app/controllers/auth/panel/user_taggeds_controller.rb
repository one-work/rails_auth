module Auth
  class Panel::UserTaggedsController < Panel::BaseController
    before_action :set_user_tag
    before_action :set_user_tagged, only: [:show, :edit, :update]

    def index
      @user_taggeds = @user_tag.user_taggeds.page(params[:page])
    end

    def search
      @select_ids = @user_tag.users.default_where('accounts.identity': params[:identity]).pluck(:id)
      @users = User.default_where('accounts.identity': params[:identity])
    end

    def destroy
      if params[:id]
        @user_tagged = @user_tag.user_taggeds.find params[:id]
      elsif params[:user_id]
        @user_tagged = @user_tag.user_taggeds.find_by(user_id: params[:user_id])
      end

      @user_tagged.destroy if @user_tagged
    end

    private
    def set_user_tag
      @user_tag = UserTag.find params[:user_tag_id]
    end

    def set_user_tagged
      @user_tagged = @user_tag.user_taggeds.find params[:id]
    end

    def set_new_user_tagged
      @user_tagged = @user_tag.user_taggeds.build(user_tagged_params)
    end

    def user_tagged_params
      params.fetch(:user_tagged, {}).permit(
        :user_id
      )
    end

  end
end
