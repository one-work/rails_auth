json.user @wechat_user.user, partial: 'user', as: :user
json.wechat_user @wechat_user, partial: 'wechat_user', as: :wechat_user
json.auth_token @wechat_user.account.auth_token
