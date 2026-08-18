module Auth
  class AppsController < BaseController
    before_action :set_app, only: [:log]

    def index
      @apps = App.with_attached_logo.page(params[:page])
      @recent_apps = App.with_attached_logo.page(params[:page]).limit(4)
    end

    def log
      @app_view = @app.app_views.find_or_create_by(session_id: session.id) do |app_view|
        app_view.view_at = Time.current
      end
    end

    private
    def set_app
      @app = App.find params[:id]
    end

  end
end