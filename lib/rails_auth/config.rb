module RailsAuth #:nodoc:
  mattr_accessor :config, default: ActiveSupport::OrderedOptions.new

  config.default_return_hash = {
    controller: '/home'
  }
  config.default_home_path = '/'
  config.default_return = ->(user) {
    '/'
  }

end
