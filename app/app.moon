lapis = require "lapis"
bcrypt = require "bcrypt"
User = require "models.user"
Auth = require "controllers.auth"

class extends lapis.Application
  @enable "etlua"
  layout: "layout"

  -- Include Auth routes
  @include Auth

  -- Load current user before each request
  @before_filter =>
    if @session.current_user_id
      @current_user = User\find @session.current_user_id

  -- Homepage
  [index: "/"]: =>
    render: true, current_user: @current_user

