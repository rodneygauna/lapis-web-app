import config from require "lapis.config"

-- Get environment variables with error checking
-- Note: These env vars must be listed in nginx.conf with 'env' directives
-- for nginx workers to access them (see nginx.conf lines 8-12)
pg_host = os.getenv("POSTGRES_HOST")
pg_user = os.getenv("POSTGRES_USER")
pg_pass = os.getenv("POSTGRES_PASSWORD")
pg_db = os.getenv("POSTGRES_DB")
secret_key = os.getenv("LAPIS_SECRET_KEY")

-- Validate required environment variables
unless pg_host and pg_user and pg_pass and pg_db
  error "Missing required PostgreSQL environment variables"

config "development", ->
  server "nginx"
  code_cache "off"
  num_workers 1
  port 8080
  session_name "lapis_session_dev"
  secret secret_key

  postgres ->
    host pg_host
    user pg_user
    password pg_pass
    database pg_db


-- [[ Production configuration
-- config "production", ->
--   server "nginx"
--   code_cache "on"
--   num_workers 4
--   port 8080
--   session_name "lapis_session_prod"
--   secret secret_key
--
--   postgres ->
--     host pg_host
--     user pg_user
--     password pg_pass
--     database pg_db
-- ]]