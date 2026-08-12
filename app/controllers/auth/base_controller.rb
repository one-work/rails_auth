module Auth
  class BaseController < ApplicationController
    include Controller::Application

    private
    def render_login(account)
      state = Com::State.find_by(id: params[:state])
      if state&.get?
        state.update user_id: current_user.id, destroyable: true
        render 'state_visit_get', layout: 'raw', locals: { url: state.url(scheme: request.scheme, port: request.port) }, message: t('.success')
      elsif state
        render 'state_visit', layout: 'raw', locals: { state: state }, message: t('.success')
      else
        url = RailsAuth.config.default_return.call(account.user)
        render 'visit', layout: 'raw', locals: { url:  url }, message: t('.success')
      end
    end
  end
end
