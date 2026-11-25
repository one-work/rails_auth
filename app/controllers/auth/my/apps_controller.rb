module Auth
  class My::AppsController < My::BaseController

    def index
      @apps = current_user.apps.page(params[:page])
    end

    private
    def set_new_app
      @app = current_user.apps.build(app_params)
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
