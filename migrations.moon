-- migrations.moon
db = require "lapis.db"
schema = require "lapis.db.schema"

import create_table, types from schema

{
  -- Migration to create the users table
  [1762187328]: =>
    create_table "users", {
      {"id", types.serial }
      {"email", types.varchar, unique: true, null: false}
      {"password_hash", types.varchar, null: false}
      "PRIMARY KEY (id)"
    }
  }