local config
config = require("lapis.config").config
return config("development", function()
  server("nginx")
  code_cache("off")
  num_workers(1)
  port(8080)
  session_name("my_app_session")
  secret("my_development_secret_key")
  return sqlite(function()
    return database("myapp.db")
  end)
end)
