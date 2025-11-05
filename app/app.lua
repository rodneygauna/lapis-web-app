local lapis = require("lapis")
local bcrypt = require("bcrypt")
local csrf = require("lapis.csrf")
local User = require("models.user")
local Auth = require("controllers.auth")
do
  local _class_0
  local _parent_0 = lapis.Application
  local _base_0 = {
    layout = "layout",
    [{
      index = "/"
    }] = function(self)
      self.csrf_token = csrf.generate_token(self)
      return {
        render = true,
        current_user = self.current_user
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
    __name = nil,
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
  self:include(Auth)
  self:before_filter(function(self)
    if self.session.current_user_id then
      self.current_user = User:find(self.session.current_user_id)
    end
  end)
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  return _class_0
end
