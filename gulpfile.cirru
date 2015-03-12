
= gulp $ require :gulp
= env $ or process.env.WEB_ENV :dev

switch env
  :min $ = config $ require :./webpack.min
  else $ = config $ require :./webpack.config

gulp.task :html $ \ ()
  = html $ require :gulp-cirru-html

  = assets $ require :./assets.json
  = data $ object
    :main $ ++: config.output.publicPath assets.main

  = o $ gulp.src :./index.cirru
  = o $ o.pipe (html $ object (:data data))
  o.pipe $ gulp.dest :./

gulp.task :script $ \ ()
  = script $ require :gulp-cirru-script
  = rename $ require :gulp-rename

  = o $ gulp.src :src/**/*.cirru (object (:base :src))
  = o $ o.pipe $ script (object (:dest :../lib))
  = o $ o.pipe $ rename (object (:extname :.js))
  o.pipe $ gulp.dest :./lib
