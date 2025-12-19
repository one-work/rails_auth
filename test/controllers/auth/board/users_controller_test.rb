require 'test_helper'

class Auth::Board::UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @account = auth_accounts(:one)
    @user = @account.user

    post url_for(controller: 'auth/sign', action: 'login'), params: { identity: @account.identity, password: 'secret' }, as: :turbo_stream
  end

  test 'show ok' do
    get url_for(controller: 'auth/board/users', action: 'show')
    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'auth/board/users', action: 'edit')
    assert_response :success
  end

  test 'update ok' do
    patch url_for(controller: 'auth/board/users', action: 'update'), params: { user: { name: 'a@b.c' } }, as: :turbo_stream
    @user.reload
    assert_equal 'a@b.c', @user.name
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Auth::User.count', -1) do
      delete url_for(controller: 'auth/board/users', action: 'destroy'), as: :turbo_stream
    end

    assert_response :success
  end
end
