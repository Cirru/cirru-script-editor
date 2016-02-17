
= exports.get $ \ (env)
  case env
    :dev $ {}
      :env :dev
      :host :http://repo
      :port 8082
    :build $ {}
      :env :build
      :host :http://repo
      :port 8082
