lapis = require "lapis"
bcrypt = require "bcrypt"
respond_to = require("lapis.application").respond_to
import encode_query_string from require "lapis.util"
User = require "models.user"

class App extends lapis.Application
  @enable "etlua"

  -- Shared helpers
  require_login: =>
    unless @session.current_user_id
      return redirect: "/login"

  current_user: =>
    uid = @session.current_user_id
    return uid and User\find uid

  -- Home: redirect based on session
  [index: "/"]: =>
    if @session.current_user_id
      return redirect: "/dashboard"
    else
      return redirect: "/login"

  -- Register
  [register: "/register"]: respond_to {
    GET: =>
      @title = "Register"
      @error = @params.error
      return render: "register"

    POST: =>
      email = tostring(@params.email or "")\lower!
      password = @params.password or ""

      if email == "" or password == ""
        return redirect: "/register?#{encode_query_string error: 'Email and password are required.'}"

      if User\find email: email
        return redirect: "/register?#{encode_query_string error: 'Email already registered.'}"

      hash = bcrypt.digest password, 12
      user = User\create { email: email, password_hash: hash }

      @session.current_user_id = user.id
      return redirect: "/dashboard"
  }

  -- Login
  [login: "/login"]: respond_to {
    GET: =>
      @title = "Login"
      @error = @params.error
      return render: "login"

    POST: =>
      email = tostring(@params.email or "")\lower!
      password = @params.password or ""

      user = User\find email: email
      unless user and bcrypt.verify password, user.password_hash
        return redirect: "/login?#{encode_query_string error: 'Invalid email or password.'}"

      @session.current_user_id = user.id
      return redirect: "/dashboard"
  }

  -- Logout
  [logout: "/logout"]: =>
    if @req.method == "POST"
      @session.current_user_id = nil
    return redirect: "/login"

  -- Dashboard
  [dashboard: "/dashboard"]: =>
    gate = @require_login!
    return gate if gate

    @current_user = @current_user!
    @title = "Dashboard"
    return render: "dashboard"

return App
