module.exports = (grunt) ->
  grunt.initConfig {
    
    pkg: grunt.file.readJSON 'package.json'
    
    clean: ['public/css', 'public/html', 'public/js']

    concat: {
      vinch: {
        src: [
          'bower_components/jquery/jquery.js'
          'bower_components/modernizr/modernizr.js'
          'bower_components/handlebars/handlebars.js'
          'bower_components/underscore/underscore.js'
          'bower_components/underscore.string/dist/underscore.string.min.js'
        ]
        dest: 'public/js/dependencies/vinch.js'
      }
    }

    uglify: {
      options: {
        report: 'min'
      }
      vinch: {
        files: {
          'public/js/dependencies/vinch.min.js': ['public/js/dependencies/vinch.js']
        }
      }
    }

  }

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.registerTask 'dev', ['clean', 'concat:vinch']
  grunt.registerTask 'build', ['concat:vinch', 'uglify:vinch']
