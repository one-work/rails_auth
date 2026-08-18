module Auth
  class AppsController < BaseController
    before_action :set_app, only: [:log]

    def index
      @apps = App.includes(:app_views).with_attached_logo.order(app_views: { view_at: :desc }).page(params[:page])
      @recent_apps = App.with_attached_logo.page(params[:page]).limit(4)
    end

    def log
      @app_view = @app.app_views.find_or_initialize_by(session_id: session.id.to_s)
      @app_view.view_at = Time.current
      @app_view.save

      head :ok
    end

    private
    def set_app
      @app = App.find params[:id]
    end

  end
end