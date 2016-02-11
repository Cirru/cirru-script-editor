
= exports.get $ \ (env)
  case env
    :dev $ {}
      :env :dev
      :host :http://localhost
      :port 8080
    :build $ {}
      :env :build
      :host :http://localhost
      :port 8080
