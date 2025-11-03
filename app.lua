local lapis = require("lapis")
local bcrypt = require("bcrypt")
local respond_to = require("lapis.application").respond_to
local encode_query_string
encode_query_string = require("lapis.util").encode_query_string
local User = require("models.user")
local App
do
  local _class_0
  local _parent_0 = lapis.Application
  local _base_0 = {
    require_login = function(self)
      if not (self.session.current_user_id) then
        return {
          redirect = "/login"
        }
      end
    end,
    current_user = function(self)
      local uid = self.session.current_user_id
      return uid and User:find(uid)
    end,
    [{
      index = "/"
    }] = function(self)
      if self.session.current_user_id then
        return {
          redirect = "/dashboard"
        }
      else
        return {
          redirect = "/login"
        }
      end
    end,
    [{
      register = "/register"
    }] = respond_to({
      GET = function(self)
        self.title = "Register"
        self.error = self.params.error
        return {
          render = "register"
        }
      end,
      POST = function(self)
        local email = tostring(self.params.email or ""):lower()
        local password = self.params.password or ""
        if email == "" or password == "" then
          return {
            redirect = "/register?" .. tostring(encode_query_string({
              error = 'Email and password are required.'
            }))
          }
        end
        if User:find({
          email = email
        }) then
          return {
            redirect = "/register?" .. tostring(encode_query_string({
              error = 'Email already registered.'
            }))
          }
        end
        local hash = bcrypt.digest(password, 12)
        local user = User:create({
          email = email,
          password_hash = hash
        })
        self.session.current_user_id = user.id
        return {
          redirect = "/dashboard"
        }
      end
    }),
    [{
      login = "/login"
    }] = respond_to({
      GET = function(self)
        self.title = "Login"
        self.error = self.params.error
        return {
          render = "login"
        }
      end,
      POST = function(self)
        local email = tostring(self.params.email or ""):lower()
        local password = self.params.password or ""
        local user = User:find({
          email = email
        })
        if not (user and bcrypt.verify(password, user.password_hash)) then
          return {
            redirect = "/login?" .. tostring(encode_query_string({
              error = 'Invalid email or password.'
            }))
          }
        end
        self.session.current_user_id = user.id
        return {
          redirect = "/dashboard"
        }
      end
    }),
    [{
      logout = "/logout"
    }] = function(self)
      if self.req.method == "POST" then
        self.session.current_user_id = nil
      end
      return {
        redirect = "/login"
      }
    end,
    [{
      dashboard = "/dashboard"
    }] = function(self)
      local gate = self:require_login()
      if gate then
        return gate
      end
      self.current_user = self:current_user()
      self.title = "Dashboard"
      return {
        render = "dashboard"
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
    __name = "App",
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
  local self = _class_0
  self:enable("etlua")
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  App = _class_0
end
return App
