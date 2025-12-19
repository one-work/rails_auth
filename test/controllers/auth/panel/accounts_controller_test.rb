require 'test_helper'

class Auth::Panel::AccountsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @account = auth_accounts(:one)
  end

  test 'index ok' do
    get url_for(controller: 'auth/panel/accounts')
    assert_response :success
  end

  test 'new ok' do
    get url_for(controller: 'auth/panel/accounts', action: 'new')
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Auth::Account.count') do
      post url_for(controller: 'auth/panel/accounts', action: 'create'), params: { account: { identity: 'test2@work.design' } }, as: :turbo_stream
    end

    assert_response :success
  end

  test 'show ok' do
    get url_for(controller: 'auth/panel/accounts', action: 'show', id: @account.id)
    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'auth/panel/accounts', action: 'edit', id: @account.id)
    assert_response :success
  end

  test 'update ok' do
    patch url_for(controller: 'auth/panel/accounts', action: 'update', id: @account.id), params: { identity: 'test_update@work.design' }, as: :turbo_stream
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Auth::Account.count', -1) do
      delete url_for(controller: 'auth/panel/accounts', action: 'destroy', id: @account.id), as: :turbo_stream
    end

    assert_response :success
  end

end
