lapis = require "lapis"
User = require "models.user"

class Dashboard extends lapis.Application
  require_login: =>
    unless @session.current_user_id
      return redirect: "/login"

  current_user: =>
    uid = @session.current_user_id
    return uid and User\find uid

  [dashboard: "/dashboard"]: =>
    gate = @require_login!
    return gate if gate

    @current_user = @current_user!
    @title = "Dashboard"
    return render: "dashboard"

return Dashboard
