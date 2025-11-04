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
      @error_message = @params.error_message
      render: "register"

    POST: capture_errors =>
      csrf.assert_token(@)
      email = tostring(@params.email or "")\lower!
      password = @params.password or ""
      confirm_password = @params.confirm_password or ""

      -- Validate required fields
      if email == "" or password == ""
        @error_message = "Email and password are required"
        @csrf_token = csrf.generate_token(@)
        @title = "User Registration"
        return status: 400, render: "register"

      -- Check if passwords match (fixed: was checking equality instead of inequality)
      if password != confirm_password
        @error_message = "Passwords do not match"
        @csrf_token = csrf.generate_token(@)
        @title = "User Registration"
        return status: 400, render: "register"

      -- Check if user already exists
      if User\find email: email
        @error_message = "An account with this email already exists"
        @csrf_token = csrf.generate_token(@)
        @title = "User Registration"
        return status: 400, render: "register"

      hash = bcrypt.digest password, 12
      user = User\create { email: email, password_hash: hash }

      @session.current_user_id = user.id
      return redirect_to: @url_for("index")
  }

  -- Login
  [login: "/login"]: respond_to {
    GET: =>
      @csrf_token = csrf.generate_token(@)
      @title = "Login"
      @error_message = @params.error_message
      render: "login"

    POST: capture_errors =>
      csrf.assert_token(@)

      email = tostring(@params.email or "")\lower!
      password = @params.password or ""

      -- Validate required fields
      if email == "" or password == ""
        @error_message = "Email and password are required"
        @csrf_token = csrf.generate_token(@)
        @title = "Login"
        return status: 400, render: "login"

      user = User\find email: email
      unless user and bcrypt.verify password, user.password_hash
        @error_message = "Invalid email or password"
        @csrf_token = csrf.generate_token(@)
        @title = "Login"
        return status: 400, render: "login"

      @session.current_user_id = user.id
      return redirect_to: @url_for("index")
  }

  -- Logout
  [logout: "/logout"]: =>
    if @req.method == "POST"
      csrf.assert_token(@)
      @session.current_user_id = nil
    return redirect_to: @url_for("index")

return Auth
