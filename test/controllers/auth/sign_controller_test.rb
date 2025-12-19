require 'test_helper'

class Auth::SignControllerTest < ActionDispatch::IntegrationTest

  setup do
  end

  test 'sign ok' do
    get url_for(controller: 'auth/sign', action: 'sign')
    assert_response :success
  end

  test 'post sign ok' do
    post url_for(controller: 'auth/sign', action: 'sign'), params: { identity: 'test@work.design' }, as: :turbo_stream
    assert_response :success
  end

  test 'create ok' do
    post url_for(controller: 'auth/sign', action: 'login'), params: { identity: 'test@work.design', password: 'secret' }, as: :turbo_stream
    assert_response :success
  end

  test 'logout ok' do

  end

end
