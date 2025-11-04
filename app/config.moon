import config from require "lapis.config"

config "development", ->
  server "nginx"
  code_cache "off"
  num_workers 1
  port 8080
  session_name "lapis_session_dev"
  secret os.getenv("LAPIS_SECRET") or "development_secret"
  postgres ->
    host os.getenv("POSTGRES_HOST") or "localhost"
    user os.getenv("POSTGRES_USER") or "lapis_user"
    password os.getenv("POSTGRES_PASSWORD") or "lapis_password"
    database os.getenv("POSTGRES_DB") or "lapis_db"