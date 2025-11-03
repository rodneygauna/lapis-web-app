local config
config = require("lapis.config").config
config("development", function()
  server("nginx")
  code_cache("off")
  num_workers(1)
  return port(8080)
end)
return config("production", function()
  server("nginx")
  code_cache("on")
  num_workers(4)
  return port(80)
end)
