db = require "lapis.db"
schema = require "lapis.db.schema"

import create_table, types from schema

{
  [1762236897]: =>
    create_table "users", {
      {"id", types.serial}
      {"email", types.varchar, unique: true, null: false}
      {"password_hash", types.varchar, null: false}
      {"created_at", types.time, default: db.raw("CURRENT_TIMESTAMP")}
      "PRIMARY KEY (id)"
    }
}
