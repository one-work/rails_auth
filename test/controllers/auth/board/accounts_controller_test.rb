require 'test_helper'

class Auth::Board::AccountsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @account = auth_accounts(:one)
    post url_for(controller: 'auth/sign', action: 'login'), params: { identity: @account.identity, password: 'secret' }, as: :turbo_stream
  end

  test 'index ok' do
    get url_for(controller: 'auth/board/accounts')
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Auth::Account.count') do
      post url_for(controller: 'auth/board/accounts', action: 'create'), params: { account: { identity: 'test1@work.design' } }, as: :turbo_stream
    end

    assert_response :success
  end

  test 'confirm ok' do
    post(
      url_for(controller: 'auth/board/accounts', action: 'confirm', id: @account.id),
      params: { token: @account.verify_token.token },
      as: :turbo_stream
    )

    assert_response :success
  end

  test 'update ok' do
    patch url_for(controller: 'auth/board/accounts', action: 'update', id: @account.id), params: { account: { confirmed: true } }, as: :turbo_stream
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Auth::Account.count', -1) do
      delete url_for(controller: 'auth/board/accounts', action: 'destroy', id: @account.id), as: :turbo_stream
    end

    assert_response :success
  end
end
