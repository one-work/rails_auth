module Auth
  class AppsController < BaseController
    before_action :set_app, only: [:log]

    def index
      @app_views = AppView.includes(app: { logo_attachment: :blob }).order(view_at: :desc).page(params[:page])
      @all_apps = App.with_attached_logo.page(params[:page]).limit(4)
      @apps = App.with_attached_logo.page(params[:page])
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