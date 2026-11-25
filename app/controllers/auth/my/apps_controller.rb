module Auth
  class My::AppsController < My::BaseController
    before_action :set_new_app, only: [:new, :create]

    def index
      @apps = current_user.created_apps.page(params[:page])
    end

    private
    def set_new_app
      @app = current_user.created_apps.build(app_params)
    end

    def app_params
      params.fetch(:app, {}).permit(
        :name,
        :host,
        :note,
        :logo
      )
    end

  end
end
