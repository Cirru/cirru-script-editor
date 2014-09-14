
gulp = require 'gulp'
rename = require 'gulp-rename'
sequence = require 'run-sequence'

project = 'Cirru/editor/index.html'
dev = yes
libraries = [
  'react'
]

gulp.task 'folder', ->
  filetree = require 'make-filetree'
  filetree.make '.',
    coffee:
      'main.coffee': ''
    css:
      'main.css': ''
    cirru:
      'index.cirru': ''
    'README.md': ''
    build: {}

gulp.task 'watch', ->
  plumber = require 'gulp-plumber'
  coffee = require 'gulp-coffee'
  reloader = require 'gulp-reloader'
  watch = require 'gulp-watch'
  html = require 'gulp-cirru-html'
  transform = require 'vinyl-transform'
  browserify = require 'browserify'
  reloader.listen()

  gulp
  .src 'cirru/*'
  .pipe watch()
  .pipe plumber()
  .pipe html(data: {dev: yes})
  .pipe gulp.dest('./')
  .pipe reloader(project)

  watch glob: 'coffee/**/*.coffee', emitOnGlob: no, (files) ->
    files
    .pipe plumber()
    .pipe (coffee bare: yes)
    .pipe (gulp.dest 'build/js/')

  watch glob: 'build/js/**/*.js', emitOnGlob: no, (files) ->
    gulp
    .src './build/js/main.js'
    .pipe plumber()
    .pipe transform (filename) ->
      b = browserify filename, debug: yes
      b.external library for library in libraries
      b.bundle()
    .pipe gulp.dest('build/')
    .pipe reloader(project)
    return files

  watch glob: ['server.coffee', 'src/**/*.coffee'], emitOnGlob: no, (files) ->
    wait = require 'gulp-wait'
    files
    .pipe wait(800)
    .pipe reloader(project)

gulp.task 'js', ->
  browserify = require 'browserify'
  source = require 'vinyl-source-stream'
  b = browserify debug: dev
  b.add './build/js/main'
  b.external library for library in libraries
  b.bundle()
  .pipe source('main.js')
  .pipe gulp.dest('build/')

gulp.task 'coffee', ->
  coffee = require 'gulp-coffee'
  gulp
  .src 'coffee/**/*.coffee', base: 'coffee/'
  .pipe (coffee bare: yes)
  .pipe (gulp.dest 'build/js/')

gulp.task 'html', ->
  html = require 'gulp-cirru-html'
  gulp
  .src 'cirru/*'
  .pipe html(data: {dev: dev})
  .pipe gulp.dest('.')

gulp.task 'jsmin', ->
  source = require 'vinyl-source-stream'
  uglify = require 'gulp-uglify'
  buffer = require 'vinyl-buffer'
  browserify = require 'browserify'
  b = browserify debug: no
  b.add './build/js/main'
  b.external library for library in libraries
  b.bundle()
  .pipe source('main.min.js')
  .pipe buffer()
  .pipe uglify()
  .pipe gulp.dest('dist/')

gulp.task 'vendor', ->
  source = require 'vinyl-source-stream'
  uglify = require 'gulp-uglify'
  buffer = require 'vinyl-buffer'
  browserify = require 'browserify'
  b = browserify debug: no
  b.require library for library in libraries
  jsbuffer = b.bundle()
  .pipe source('vendor.min.js')
  .pipe buffer()
  if dev
    jsbuffer
    .pipe gulp.dest('dist/')
  else
    jsbuffer
    .pipe uglify()
    .pipe gulp.dest('dist/')

gulp.task 'prefixer', ->
  prefixer = require 'gulp-autoprefixer'
  gulp
  .src 'css/**/*.css', base: 'css/'
  .pipe prefixer()
  .pipe gulp.dest('build/css/')

gulp.task 'cssmin', ->
  cssmin = require 'gulp-cssmin'
  gulp
  .src 'build/css/main.css'
  .pipe cssmin()
  .pipe rename(suffix: '.min')
  .pipe gulp.dest('dist/')

gulp.task 'clean', ->
  rimraf = require 'gulp-rimraf'
  gulp
  .src ['build/', 'dist/']
  .pipe rimraf()

gulp.task 'dev', ->
  sequence 'clean', ['html', 'coffee', 'vendor'], 'js'

gulp.task 'build', ->
  dev = no
  sequence 'clean',
    ['coffee', 'html'], ['jsmin', 'vendor'],
    'prefixer', 'cssmin'

gulp.task 'rsync', ->
  rsync = require('rsyncwrapper').rsync
  rsync
    ssh: yes
    src: '.'
    recursive: true
    args: ['--verbose']
    dest: "tiye:~/repo/simple-chat"
    deleteAll: yes
    exclude: [
      'bower_components/'
      'node_modules/'
      'cirru/'
      '.gitignore'
      '.npmignore'
      'README.md'
      'coffee/'
      'css/'
      'build/'
      'gulpfile.coffee'
      '*.json'
    ]
  , (error, stdout, stderr, cmd) ->
    if error? then throw error
    if stderr?
      console.error stderr
    else
      console.log cmd