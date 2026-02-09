module Auth
  class Panel::SessionsController < Panel::BaseController

    def index
      q_params = {}
      q_params.merge! params.permit(:id, :uid, :appid, :identity)
      @sessions = Session.default_where(q_params)
      if params[:online]
        @sessions = @sessions.where.not(online_at: nil).where(offline_at: nil)
      end

      @sessions = @sessions.order(id: :desc).page(params[:page])
    end

    private
    def set_filter_columns
      @filter_columns = set_filter_i18n(
        'id' => { type: 'search', default: true },
        'identity' => { type: 'search', default: true }
      )
    end

    def session_params
      params.fetch(:session, {}).permit(
        :identity,
        :expire_at,
        :session_key
      )
    end

  end
end
