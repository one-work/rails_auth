module Auth
  class AppsController < BaseController
    before_action :set_app, only: [:log, :star, :unstar]

    def index
      @app_views = AppView.viewed.includes(app: { logo_attachment: :blob }).where(session_id: session.id.to_s).order(view_at: :desc).limit(4)
      @all_apps = AppView.includes(app: { logo_attachment: :blob }).where(session_id: session.id.to_s).page(params[:page]).limit(4)
      @star_ids = AppView.where(session_id: session.id.to_s, starred: true).pluck(:app_id)
      @apps = App.with_attached_logo.page(params[:page])
    end

    def star
      @app_view = @app.app_views.find_or_initialize_by(session_id: session.id.to_s)
      @app_view.starred = true
      @app_view.save

      @star_ids = [@app.id]
    end

    def unstar
      @app_view = @app.app_views.find_by(starred: true, session_id: session.id.to_s)
      if @app_view.present?
        @app_view.destroy
      end

      @star_ids = []
    end

    def log
      @app_view = @app.app_views.find_or_initialize_by(session_id: session.id.to_s)
      @app_view.view_at = Time.current
      @app_view.save
    end

    private
    def set_app
      @app = App.find params[:id]
    end

  end
end