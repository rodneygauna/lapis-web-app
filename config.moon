-- config.moon
import config from require "lapis.config"

config "development", ->
  -- existing configuration
  server "nginx"
  code_cache "off"
  num_workers 1

  -- new configuration settings
  port 8080
  session_name "my_app_session"
  secret "my_development_secret_key"

  -- SQLite database configuration
  sqlite ->
    database "myapp.db"
