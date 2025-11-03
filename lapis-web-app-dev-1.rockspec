package = "lapis-web-app"
version = "dev-1"

source = {
  url = "https://github.com/rodneygauna/lapis-web-app.git"
}

description = {
  summary = "Lapis Application",
  homepage = "",
  license = ""
}

dependencies = {
  "lua ~> 5.1",
  "lapis == 1.16.0",
  "moonscript",
  "lsqlite3"
}

build = {
  type = "none"
}
