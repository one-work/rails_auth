module Auth
  module Controller::Application
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :current_client, :current_account, :current_session
      after_action :set_auth_token
    end

    private
    def require_user(app = nil)
      check_jwt_token if params[:auth_jwt_token]
      resume_session || request_authentication
    end

    def check_jwt_token
      @current_session = Session.find_or_create_by(encrypted_token: params[:auth_jwt_token])
    end

    def current_user
      return @current_user if defined?(@current_user)
      check_jwt_token if params[:auth_jwt_token]
      resume_session
      @current_user = Current.user
      logger.debug "\e[35m  Current User: #{@current_user&.id}  \e[0m"
      @current_user
    end

    def client_params
      if current_client
        { member_id: current_client.id }
      elsif current_user
        { user_id: current_user.id, member_id: nil }
      else
        { user_id: nil, member_id: nil }
      end
    end

    def require_client
      return if current_client

      render 'require_client', layout: 'raw', locals: { url: url_for(state: state_enter(destroyable: false).id) }
    end

    def current_client
      return @current_client if defined?(@current_client)
      @current_client = Current.session.member
      logger.debug "\e[35m  Current Client: #{@current_client&.id}  \e[0m"
      @current_client
    end

    def current_account
      resume_session
      Current.session&.oauth_user
    end

    def current_session
      return @current_session if defined?(@current_session)
      token = params[:auth_token].presence || cookies.signed[:session_id]

      return unless token
      session = Session.find_by(id: token)
      if session&.expired?
        @current_session = session.refresh
      else
        @current_session = session
      end
      logger.debug "\e[35m  Current Authorized Token: #{@current_session&.id}, Destroyed: #{@current_session&.destroyed?}  \e[0m"
      @current_session
    end

    def login_by_account(account)
      @current_account = account
      @current_user = @current_account.user
      @current_session = @current_account.session

      logger.debug "\e[35m  Login by account #{account.id} as user: #{account.user_id}  \e[0m"
    end

    private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      if params[:auth_token].present?
        session = Session.find_by_token_for(:once, params[:auth_token])
      elsif cookies[:session_id]
        session = Session.find_by(id: cookies.signed[:session_id])
      elsif request.format.json?
        token = request.headers['Authorization'].to_s.split(' ').last.presence
        session = Session.find_by(id: token)
      else
        return
      end

      Current.session ||= session
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to controller: 'auth/sessions', action: 'new', identity: params[:identity], state: state_enter(destroyable: false).id
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def start_new_session_for(account)
      account.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        set_session_to_cookie(session)
      end
    end

    def terminate_session
      Current.session&.destroy
      Current.session = nil
      cookies.delete(:session_id)
    end

    def set_session_to_cookie(session)
      cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
    end

    def set_auth_token
      resume_session
      return unless Current.session

      if Current.session.expired?
        Current.session.refresh!
        set_session_to_cookie(Current.session)
      elsif cookies[:session_id].blank?
        set_session_to_cookie(Current.session)
      else
        set_session_to_cookie(Current.session)
      end
      logger.debug "\e[35m  Set session Auth token: #{cookies[:session_id]}  \e[0m"
    end

    def set_session_for_json
      headers['Authorization'] = @current_session.id
      logger.debug "\e[35m  Set session Auth token: #{session[:auth_token]}  \e[0m"
    end

  end
end
