
gulp = require 'gulp'
env = process.env.WEB_ENV or 'dev'

switch env
  when 'min'
    config = require './webpack.min'
  else
    config = require './webpack.config'

gulp.task 'html', ->
  html = require 'gulp-cirru-html'

  assets = require './assets.json'
  data =
    main: "#{config.output.publicPath}#{assets.main}"

  gulp
  .src './index.cirru'
  .pipe html(data: data)
  .pipe gulp.dest('./')

gulp.task 'rsync', ->
  console.log 'rsync'
