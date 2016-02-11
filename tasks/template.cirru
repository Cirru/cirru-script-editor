
var
  stir $ require :stir-template
  settings $ require :./settings
  resource $ require :./resource
  ({}~ html head title meta link script body div style) stir

  logoUrl :http://logo.cirru.org/cirru-32x32.png

= module.exports $ \ (env)
  var
    config $ settings.get env
    assets $ resource.get config

  stir.render
    stir.doctype
    html null
      head null
        title null ":Cirru Editor"
        meta $ {} :charset :utf-8
        link $ {} :rel :icon :href logoUrl
        cond (? assets.style)
          link $ {} :rel :stylesheet :href assets.style
        script $ {} :src assets.vendor :defer true
        script $ {} :src assets.main :defer true
        style null ":body * {box-sizing: border-box;}"
      body ({} :style ":margin: 0;")
        div ({} :id :app)
