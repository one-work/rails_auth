require 'test_helper'
class Auth::Panel::AppsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @app = apps(:one)
  end

  test 'index ok' do
    get url_for(controller: 'auth/panel/apps')

    assert_response :success
  end

  test 'new ok' do
    get url_for(controller: 'auth/panel/apps')

    assert_response :success
  end

  test 'create ok' do
    assert_difference('App.count') do
      post(
        url_for(controller: 'auth/panel/apps', action: 'create'),
        params: { app: { appid: @auth_panel_app.appid, jwt_key: @auth_panel_app.jwt_key } },
        as: :turbo_stream
      )
    end

    assert_response :success
  end

  test 'show ok' do
    get url_for(controller: 'auth/panel/apps', action: 'show', id: @app.id)

    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'auth/panel/apps', action: 'edit', id: @app.id)

    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'auth/panel/apps', action: 'update', id: @app.id),
      params: { app: { appid: @auth_panel_app.appid, jwt_key: @auth_panel_app.jwt_key } },
      as: :turbo_stream
    )

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('App.count', -1) do
      delete url_for(controller: 'auth/panel/apps', action: 'destroy', id: @app.id), as: :turbo_stream
    end

    assert_response :success
  end

end
