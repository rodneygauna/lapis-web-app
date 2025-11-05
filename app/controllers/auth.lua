local lapis = require("lapis")
local bcrypt = require("bcrypt")
local csrf = require("lapis.csrf")
local respond_to = require("lapis.application").respond_to
local capture_errors = require("lapis.application").capture_errors
local encode_query_string
encode_query_string = require("lapis.util").encode_query_string
local User = require("models.user")
local Auth
do
  local _class_0
  local _parent_0 = lapis.Application
  local _base_0 = {
    [{
      register = "/register"
    }] = respond_to({
      GET = function(self)
        self.csrf_token = csrf.generate_token(self)
        self.title = "User Registration"
        self.error_message = self.params.error_message
        return {
          render = "register"
        }
      end,
      POST = capture_errors(function(self)
        csrf.assert_token(self)
        local email = tostring(self.params.email or ""):lower()
        local password = self.params.password or ""
        local confirm_password = self.params.confirm_password or ""
        if email == "" or password == "" then
          self.error_message = "Email and password are required"
          self.csrf_token = csrf.generate_token(self)
          self.title = "User Registration"
          return {
            status = 400,
            render = "register"
          }
        end
        if password ~= confirm_password then
          self.error_message = "Passwords do not match"
          self.csrf_token = csrf.generate_token(self)
          self.title = "User Registration"
          return {
            status = 400,
            render = "register"
          }
        end
        if User:find({
          email = email
        }) then
          self.error_message = "An account with this email already exists"
          self.csrf_token = csrf.generate_token(self)
          self.title = "User Registration"
          return {
            status = 400,
            render = "register"
          }
        end
        local hash = bcrypt.digest(password, 12)
        local user = User:create({
          email = email,
          password_hash = hash
        })
        self.session.current_user_id = user.id
        return {
          redirect_to = self:url_for("index")
        }
      end)
    }),
    [{
      login = "/login"
    }] = respond_to({
      GET = function(self)
        self.csrf_token = csrf.generate_token(self)
        self.title = "Login"
        self.error_message = self.params.error_message
        return {
          render = "login"
        }
      end,
      POST = capture_errors(function(self)
        csrf.assert_token(self)
        local email = tostring(self.params.email or ""):lower()
        local password = self.params.password or ""
        if email == "" or password == "" then
          self.error_message = "Email and password are required"
          self.csrf_token = csrf.generate_token(self)
          self.title = "Login"
          return {
            status = 400,
            render = "login"
          }
        end
        local user = User:find({
          email = email
        })
        if not (user and bcrypt.verify(password, user.password_hash)) then
          self.error_message = "Invalid email or password"
          self.csrf_token = csrf.generate_token(self)
          self.title = "Login"
          return {
            status = 400,
            render = "login"
          }
        end
        self.session.current_user_id = user.id
        return {
          redirect_to = self:url_for("index")
        }
      end)
    }),
    [{
      logout = "/logout"
    }] = function(self)
      if self.req.method == "POST" then
        csrf.assert_token(self)
        self.session.current_user_id = nil
      end
      return {
        redirect_to = self:url_for("index")
      }
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Auth",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Auth = _class_0
end
return Auth
