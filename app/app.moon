lapis = require "lapis"

class extends lapis.Application
  @enable "etlua"
  layout: "layout"

  -- Homepage
  "/": =>
    return render: "index"
