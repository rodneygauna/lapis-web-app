lapis = require "lapis"
bcrypt = require "bcrypt"
csrf = require "lapis.csrf"
respond_to = require("lapis.application").respond_to
capture_errors = require("lapis.application").capture_errors
import encode_query_string from require "lapis.util"
User = require "models.user"

class Auth extends lapis.Application
  -- Register
  [register: "/register"]: respond_to {
    GET: =>
      @csrf_token = csrf.generate_token(@)
      @title = "User Registration"
      @error = @params.error
      render: "register"

    POST: capture_errors =>
      csrf.assert_token(@)
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
      @csrf_token = csrf.generate_token(@)
      @title = "Login"
      @error = @params.error
      render: "login"

    POST: capture_errors =>
      csrf.assert_token(@)

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
      csrf.assert_token(@)
      @session.current_user_id = nil
    return redirect_to: @url_for("index")

return Auth
