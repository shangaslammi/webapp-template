fs   = require 'fs'
path = require 'path'

module.exports = (grunt) ->
  components = grunt.file.expand("src/coffee/components/*.coffee").map((c) -> path.basename(c, ".coffee"))

  grunt.initConfig
    template:
      loader:
        options:
          data:
            components: components
        files:
          'src/coffee/components.coffee':  ['src/coffee/components.coffee.tmpl']

    coffee:
      compile:
        cwd: "src/coffee"
        src: ["**/*.coffee"]
        dest: "public/js/modules/"
        ext: ".js"
        expand: true
        flatten: false
        bare: false
      devel:
        options:
          sourceMap: true
        cwd: "public/js/modules"
        src: ["**/*.coffee"]
        dest: "public/js/modules/"
        ext: ".js"
        expand: true
        flatten: false
        bare: false


    jade:
      compile:
        files: [
          cwd: "src/jade/"
          src: ["[^_]*.jade"]
          dest: "public/"
          ext: ".html"
          expand: true
        ]
        options:
            data:
              development: true

      prod:
        files: [
          cwd: "src/jade/"
          src: ["[^_]*.jade"]
          dest: "public/"
          ext: ".html"
          expand: true
        ]
        options:
            data:
              development: false

      components:
        files: [
          cwd: "src/jade/components"
          src: ["[^_]*.jade"]
          dest: "public/components"
          ext: ".html"
          expand: true
        ]

    stylus:
      options:
        compress: true
      compile:
        files: [
          cwd: "src/stylus/"
          src: ["[^_]*.styl"]
          dest: "public/css"
          ext: ".css"
          expand: true
        ]
      components:
        files:
          'public/css/components.css': ['src/stylus/components/**/*.styl']



    connect:
      server:
        options:
          port: 8000
          base: 'public'
          middleware: (connect, options, middlewares) ->
            middlewares.push (req, res, next) -> switch
              when /\/(components|js|css)\//.exec req.url
                res.writeHead 404, {'Content-Type': 'text/html'}
                res.end("Not found")
              else
                res.writeHead 200, {'Content-Type': 'text/html'}
                fs.createReadStream('public/index.html').pipe res
            return middlewares

    watch:
      coffee:
        files: ["src/coffee/**/*.coffee"]
        tasks: ["copy:sources", "newer:coffee:devel"]

      stylus:
        files: ["src/stylus/**/*.styl"]
        tasks: ["stylus:compile"]

      jade:
        files: ["src/jade/*.jade"]
        tasks: ["jade:compile"]

      components:
        files: ["src/jade/components/*.jade"]
        tasks: ["newer:jade:components"]

      css:
        files: ["public/css/**/*.css"]
        options:
          livereload:
            port: 35729

      html:
        files: ["public/**/*.html"]
        options:
          livereload:
            port: 35729

      js:
        files: ["public/js/**/*.js"]
        options:
          livereload:
            port: 35729

      grunt:
        files: ["Gruntfile.coffee"]

    clean:
      html: ['public/components/*.html', 'public/*.html']
      vendor: ['public/js/vendor']
      js: ['public/js/**/*.js']
      css: ['public/css/**/*.css']
      build: ['build/**/*.coffee', 'build/**/*.map']

    copy:
      main:
        files: [
          {expand: true, src: ['vendor/**'], dest: 'public/js'}
        ]
      sources:
        files: [
          expand: true
          cwd: 'src/coffee'
          src: '**/*.coffee'
          dest: 'public/js/modules/'
        ]

    filerev:
      options:
        encoding: 'utf8'
        algorithm: 'md5'
        length: 8
      js:
        src: ['build/js/modules/app.js']
      css:
        src: ['build/css/*.css']
      images:
        src: ['build/images/**/*.{svg,jpg,jpeg,gif,png,webp}']

    usemin:
      html: 'build/*.html'
      css: 'build/css/*.css'
      app: 'build/index.html'

      options:
        assetDirs: 'build'
        patterns:
          app: [ [
              /app: '(\/js\/modules\/app)'/gm
            ,
              'Add mapping for app module'
            ,
              (m) -> "js/modules/app.js"
            ,
              (dst) -> "/" + dst.replace('.js', '')
            ]
          ]

    requirejs:
      compile:
        options:
          mainConfigFile: 'public/js/modules/app.js'
          appDir: 'public'
          baseUrl: 'js/modules'
          dir: 'build'
          modules: [
            name: 'app'
            exclude: [
              'jquery'
            ]
          ]
          throwWhen:
            optimize: false
          skipDirOptimize: true
          removeCombined: true
          preserveLicenseComments: false
          useSourceUrl: false

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-requirejs"
  grunt.loadNpmTasks "grunt-newer"
  grunt.loadNpmTasks "grunt-filerev"
  grunt.loadNpmTasks "grunt-usemin"
  grunt.loadNpmTasks "grunt-template"

  grunt.registerTask "default", ["template", "copy", "coffee:devel", "jade:compile", "jade:components", "stylus", "connect", "watch"]
  grunt.registerTask "build", ["clean", "template", "copy:main", "coffee:compile", "jade", "jade:prod", "stylus", "requirejs", "filerev", "usemin", "clean:build"]
