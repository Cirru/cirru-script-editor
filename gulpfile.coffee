
gulp = require 'gulp'

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
  watch = require 'gulp-watch'
  html = require 'gulp-cirru-html'
  transform = require 'vinyl-transform'
  browserify = require 'browserify'
  rename = require 'gulp-rename'

  watch glob: 'cirru/*', emitOnGlob: no, (files) ->
    gulp
    .src 'cirru/index.cirru'
    .pipe plumber()
    .pipe html(data: {dev: yes})
    .pipe gulp.dest('./')

  watch glob: 'coffee/**/*.coffee', emitOnGlob: no, (files) ->
    files
    .pipe plumber()
    .pipe (coffee bare: yes)
    .pipe (gulp.dest 'build/js/')
    .pipe rename('main.js')
    .pipe transform (filename) ->
      b = browserify filename, debug: yes
      b.external library for library in libraries
      b.bundle()
    .pipe gulp.dest('build/')
    return files

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
  rename = require 'gulp-rename'
  cssmin = require 'gulp-cssmin'
  gulp
  .src 'build/css/main.css'
  .pipe cssmin(root: 'build/css')
  .pipe rename(suffix: '.min')
  .pipe gulp.dest('dist/')

gulp.task 'clean', (cb) ->
  del = require 'del'
  del ['build/', 'dist/'], cb

gulp.task 'dev', ->
  sequence = require 'run-sequence'
  sequence 'clean', ['html', 'coffee', 'vendor'], 'js'

gulp.task 'build', ->
  dev = no
  sequence = require 'run-sequence'
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
    dest: "tiye:~/repo/Cirru/editor"
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