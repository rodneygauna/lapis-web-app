lapis = require "lapis"
bcrypt = require "bcrypt"
respond_to = require("lapis.application").respond_to
import encode_query_string from require "lapis.util"
User = require "models.user"

class Auth extends lapis.Application
  -- Register
  [register: "/register"]: respond_to {
    GET: =>
      @title = "User Registration"
      @error = @params.error
      render: "register"

    POST: =>
      email = tostring(@params.email or "")\lower!
      password = @params.password or ""
      confirm_password = @params.confirm_password or ""

      if email == "" or password == ""
        return redirect: "/register"

      if email == confirm_password
        return redirect: "/register"

      if User\find email: email
        return redirect: "/register"

      hash = bcrypt.digest password, 12
      user = User\create { email: email, password_hash: hash }

      @session.current_user_id = user.id
      return redirect_to: "/"
  }

  -- Login
  [login: "/login"]: respond_to {
    GET: =>
      @title = "Login"
      @error = @params.error
      render: "login"

    POST: =>
      email = tostring(@params.email or "")\lower!
      password = @params.password or ""

      user = User\find email: email
      unless user and bcrypt.verify password, user.password_hash
        return redirect_to: @url_for("login")

      @session.current_user_id = user.id
      return redirect_to: "/"
  }

  -- Logout
  [logout: "/logout"]: =>
    if @req.method == "POST"
      @session.current_user_id = nil
    return redirect_to: @url_for("index")

return Auth
