-- app/models/user.moon
import Model from require "lapis.db.model"

class User extends Model
  @primary_key: "id"
  @table_name: => "users"
  @timestamp: true
