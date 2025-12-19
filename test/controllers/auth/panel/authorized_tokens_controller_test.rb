require 'test_helper'

class Auth::Panel::AuthorizedTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @authorized_token = auth_authorized_tokens(:one)
  end

  test 'index ok' do
    get url_for(controller: 'auth/panel/authorized_tokens')
    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'auth/panel/authorized_tokens', action: 'edit', id: @authorized_token.id)
    assert_response :success
  end

  test 'update ok' do
    patch url_for(controller: 'auth/panel/authorized_tokens', action: 'update', id: @authorized_token.id), params: { authorized_token: { expire_at: Time.now } }, as: :turbo_stream
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Auth::AuthorizedToken.count', -1) do
      delete url_for(controller: 'auth/panel/authorized_tokens', action: 'destroy', id: @authorized_token.id), as: :turbo_stream
    end

    assert_response :success
  end

end
