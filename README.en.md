# RailsAuth

TheAuth is a Rails Engine for user authentication, more easy to use, more easy to override.


## Description

There are so many gems about auth, I separated the engine from our projects because of:

- more easy to understand and use, for example, `devise` is good, but difficult to override and config, it's unfriendly to fresh developers;
- more easy to config, just normal rails controller model and views;
- used `ActiveModel::SecurePassword` which was default included by rails, make so easy to deal with Password;

## How To Use


### Include in Controller

```ruby
# api
class ApplicationController < ActionController::Base
  include Auth::Controller::Application
end
```

### Include in Model
```ruby
class User < ApplicationRecord
  include Auth::Model::User
end
```

## methods RailsAuth provided：

```ruby
# in controller
current_user
```
