module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compile:
        cwd: "src/coffee"
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

    stylus:
      compile:
        files:
          "public/css/styles.css": "src/stylus/*.styl"

        options:
          compress: true

    connect:
      server:
        options:
          port: 8000
          base: 'public'

    watch:
      coffee:
        files: ["src/coffee/**/*.coffee"]
        tasks: ["newer:coffee:compile"]

      stylus:
        files: ["src/stylus/*.styl"]
        tasks: ["newer:stylus:compile"]

      jade:
        files: ["src/jade/*.jade"]
        tasks: ["newer:jade:compile"]

      css:
        files: ["public/css/**.css"]
        options:
          livereload: true

      html:
        files: ["public/**.html"]
        options:
          livereload: true

      js:
        files: ["public/js/**.js"]
        options:
          livereload: true

      grunt:
        files: ["Gruntfile.coffee"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-newer"

  grunt.registerTask "default", ["coffee", "jade", "stylus", "connect", "watch"]
  grunt.registerTask "build", ["coffee", "jade", "stylus"]
