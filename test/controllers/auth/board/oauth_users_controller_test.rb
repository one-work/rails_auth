require 'test_helper'
class Auth::Board::OauthUsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    account = auth_accounts(:one)
    post url_for(controller: 'auth/sign', action: 'login'), params: { identity: account.identity, password: 'secret' }, as: :turbo_stream

    @oauth_user = auth_oauth_users(:one)
  end

  test 'index ok' do
    get url_for(controller: 'auth/board/oauth_users')
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Auth::OauthUser.count', -1) do
      delete url_for(controller: 'auth/board/oauth_users', action: 'destroy', id: @oauth_user.id), as: :turbo_stream
    end

    assert_response :success
  end
end
