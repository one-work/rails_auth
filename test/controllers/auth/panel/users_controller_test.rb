require 'test_helper'

class Auth::Panel::UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @account = auth_accounts(:one)
    @user = @account.user

    post url_for(controller: 'auth/sign', action: 'login'), params: { identity: @account.identity, password: 'secret' }, as: :turbo_stream
  end

  test 'show ok' do
    get url_for(controller: 'auth/panel/users')
    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'auth/panel/users', action: 'edit', id: @user.id)
    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'auth/panel/users', action: 'update', id: @user.id),
      params: { user: { name: 'a@b.c' } },
      as: :turbo_stream
    )
    @user.reload
    assert_equal 'a@b.c', @user.name
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Auth::User.count', -1) do
      delete url_for(controller: 'auth/panel/users', action: 'destroy', id: @user.id), as: :turbo_stream
    end

    assert_response :success
  end
end
