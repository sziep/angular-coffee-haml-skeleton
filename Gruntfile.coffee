module.exports = (grunt)->

  #load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  ###############################################################
  # Constants
  ###############################################################
  
  APP         =   "app"
  PUBLIC      =   "public"
  ASSETS      =   "#{PUBLIC}/assets"

  STAGE       =   "stage"
  STAGE_APP   =   "#{STAGE}/app"
  BOWER       =   "#{STAGE_APP}/components"

  ###############################################################
  # ASSET DEPENDENCIES
  ###############################################################

  
  bowerAssets = {
    css: [
      "skeleton/stylesheets/*"
    ]
    scss: [
      "font-awesome/scss/font-awesome.scss"
    ]
    fonts: [
      "font-awesome/fonts/*"
    ]
    js: [
      "angular/angular.js",
    ]
    coffee: [
      "angular/*.coffee",
    ]
    images: [
      "skeleton/**/*.png",
    ]
  }

  ###############################################################
  # Config
  ###############################################################

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    express:
      livereloadServer:
        options:
          port: 8000
          bases: ["public"]
          livereload: true
          #serverreload: true
          open: true

    watch:
      css:
        files: ["#{APP}/**/*.scss"]
        tasks: ['sass:dist', 'concat:css']

      coffee:
        files: ["#{APP}/**/*.coffee"]
        tasks: ['coffee:dist', 'concat:js']

      haml:
        files: ["#{APP}/**/*.haml"]
        tasks: ['haml:dist', 'ngtemplates', 'concat:js']

      test:
        files: ["test/**/*.coffee"]
        tasks: ['coffee:test']

    clean:
      public:
        src: PUBLIC
      stage:
        src: STAGE

    copy:

      # Copy app to stage dir. 
      stage:
        files: [
           {
              expand:        true
              cwd:           APP
              src:           '**'
              dest:          STAGE_APP
           }
        ]

      static:
        files: [
          # bower assets: css
          {
             expand:  true
             cwd:     BOWER
             src:     bowerAssets.css
             flatten:  true
             dest:    "#{STAGE}/css/lib"
          },
          # bower assets: fonts
          {
             expand:  true
             cwd:     BOWER
             src:     bowerAssets.fonts
             flatten: true
             dest:    "#{ASSETS}/fonts"
          },
          # bower assets: js (js|coffee)
          {
             expand:  true
             cwd:     BOWER
             src:     bowerAssets.js
             flatten: true
             dest:    "#{STAGE}/js/lib"
          },
          # bower assets: images
          {
             expand:  true
             cwd:     BOWER
             src:     bowerAssets.images
             flatten: true
             dest:    "#{ASSETS}/images"
          },
          # app stuff
          {
             expand:  true
             cwd:     APP
             dest:    PUBLIC
             src: ['*.{ico,txt,html}']
          }
        ]

    sass:
      lib: 
        files: [ 
          # bower assets: scss
          {
            expand: true
            cwd: BOWER
            src: bowerAssets.scss
            dest: "#{STAGE}/css/lib"
            flatten: true
            ext: '.css'
          }
        ]
      dist: 
        files: [ 
          # app assets
          {
            expand: true
            cwd: "#{APP}/styles"
            src: ["app.scss"]
            dest: "#{STAGE}/css/app"
            flatten: true
            ext: '.css'
          }
        ]

    coffee:
      lib:
        expand: true
        flatten: true
        cwd: BOWER
        src: bowerAssets.coffee
        dest: "#{STAGE}/js/lib"
        ext: '.js'

      dist:
        src: "#{APP}/scripts/**/*.coffee"
        dest: "#{STAGE}/js/app/app.js"

      test:
        expand: true
        cwd: "test"
        src: ["**/*.coffee"]
        dest: "#{STAGE}/test"
        ext: '.js'

    depconcat:
      lib:
        files: [
          {
            src: ["#{STAGE}/js/lib/*"]
            dest: "#{STAGE}/js/lib.js"
          }
        ]

    haml: 
      options: 
        language: 'ruby'
      dist: 
        files: [
          {
            expand: true,
            cwd: "#{APP}/views"
            src: '{,*/}*.haml'
            dest: "#{STAGE}/templates"
            ext: '.html'
          },{
            expand: true,
            cwd: APP
            src: 'index.haml'
            dest: PUBLIC
            ext: '.html'
          }
        ]

    ngtemplates:
      app:
        cwd:  "#{STAGE}/templates"
        src:  "*"
        dest: "#{STAGE}/js/app/templates.js"
        options:
          htmlmin:
            collapseWhitespace: true
            collapseBooleanAttributes: true

    concat:
      js:
        src: ["#{STAGE}/js/lib.js", "#{STAGE}/js/app/*"]
        dest: "#{ASSETS}/js/app.js"
      css:
        src: ["#{STAGE}/css/lib/*", "#{STAGE}/css/app/*"]
        dest: "#{ASSETS}/css/app.css"
   
    ngmin: 
      dist: 
        files: [
          {
            expand: true
            cwd: "#{ASSETS}/js"
            src: '*.js'
            dest: "#{ASSETS}/js"
          }
        ]

    imagemin:
      dist:
        files: [
          {
            expand: true,
            cwd: "#{PUBLIC}/images"
            src: '{,*/}*.{png,jpg,jpeg}',
            dest: "#{PUBLIC}/images"
          }
        ]
    
    cssmin:
      options:
        banner: "/*! <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today('dd/mm/yyyy') %> */",
        report: "gzip"
        keepSpecialComments: 0

      css:
        src: "#{ASSETS}/css/app.css"
        dest: "#{ASSETS}/css/app.css"

    uglify:
      js:
        src: "#{ASSETS}/js/app.js"
        dest: "#{ASSETS}/js/app.js"



   ###############################################################
   # Alias tasks
   ###############################################################

  grunt.registerTask('build', [
    'clean',
    'copy',
    'sass',
    'coffee',
    'depconcat',
    'haml',
    'ngtemplates',
    'concat',
  ])

  grunt.registerTask('release', [
    'build'
    'ngmin',
    'imagemin'
    'cssmin'
    'uglify'
    'clean:stage',
  ])

  grunt.registerTask('server', [
    'build'
    'express'
    'watch'
  ])

  grunt.registerTask('releaseserver', [
    'release'
    'express'
    'watch'
  ])


  grunt.registerTask('default', ['server']);


