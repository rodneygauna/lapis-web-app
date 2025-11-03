local lapis = require("lapis")
local User = require("models.user")
local Dashboard
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
    __name = "Dashboard",
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
  Dashboard = _class_0
end
return Dashboard
