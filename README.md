# RailsAuth

[![测试](https://github.com/work-design/rails_auth/actions/workflows/test.yml/badge.svg)](https://github.com/work-design/rails_auth/actions/workflows/test.yml)
[![Docker构建](https://github.com/work-design/rails_auth/actions/workflows/cd.yml/badge.svg)](https://github.com/work-design/rails_auth/actions/workflows/cd.yml)
[![Gem](https://github.com/work-design/rails_auth/actions/workflows/gempush.yml/badge.svg)](https://github.com/work-design/rails_auth/actions/workflows/gempush.yml)

用于处理鉴权

## 特性

* [系列项目说明](https://github.com/work-design/home)
* 使用`Rails`自带的`ActiveModel::SecurePassword`模块处理密码;
* 使用`auth_token`统一鉴权，兼容 api 和 cookies, 服务端可控制 auth_token 失效；
* 架构:
  - 为合并用户提供了灵活的架构基础；
  - 支持多终端登录；
  - 采用全局唯一 User 设计，通过 UserTag 标签
  - 在部分场景下，通过`UserTag`自动打标签；

## 文件说明
如果用户表和项目表分离存贮，注意不要在项目中使用`users`, `accounts`, `oauth_users`任何一张表作为连表查询的中间表。

## 如何使用

## 模型：
* User
* Account
* OauthUser
* App
* AuthorizedToken: 授权token
* VerifyToken: 验证Token

```ruby
class ApplicationController < ActionController::Base
  include Auth::Controller::Application
  before_action :require_login
end
```

#### Include in Model

```ruby
class User < ActiveRecord::Base
  include Auth::Model::User
end
```

## The methods RailsAuth provided：

```ruby
# in controller
current_user

# in view with helper method
current_user
```

## 许可证
遵循 [MIT](https://opensource.org/licenses/MIT) 协议
