
module.exports = (grunt) ->
  grunt.initConfig
    jade:
      options:
        data:
          debug: no
        pretty: yes
      compile:
        files:
          'build/index.html': 'jade/index.jade'
      template:
        cwd: 'jade/'
        expand: yes
        src: '*-template.jade'
        dest: 'build/'
        ext: '.html'
    stylus:
      options: {}
      compile:
        files:
          'build/layout.css': 'stylus/index.styl'
    browserify:
      options:
        transform: ['coffeeify']
        debug: yes
      compile:
        files:
          'build/bundle.js': 'coffee/main.coffee'
    watch:
      options:
        spawn: yes
        livereload: yes
        debounceDelay: 100
      stylus:
        files: ['stylus/*.styl']
        tasks: ['stylus']
      jade:
        files: ['jade/*.jade']
        tasks: ['jade']
      browserify:
        files: ['coffee/*.coffee']
        tasks: ['browserify']

  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'once', ['jade', 'stylus', 'browserify']