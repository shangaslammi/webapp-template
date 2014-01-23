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
        files:
          "public/index.html": "src/jade/index.jade"

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
        tasks: ["coffee"]

      stylus:
        files: ["src/stylus/*.styl"]
        tasks: ["stylus"]

      jade:
        files: ["src/jade/*.jade"]
        tasks: ["jade"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"

  grunt.registerTask "default", ["coffee", "jade", "stylus", "connect", "watch"]
  grunt.registerTask "build", ["coffee", "jade", "stylus"]
