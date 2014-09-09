module.exports = (grunt) ->
  grunt.initConfig {
    pkg: grunt.file.readJSON 'package.json'
    concat: {
      vinch: {
        src: [
          'bower_components/jquery/jquery.js'
          'bower_components/modernizr/modernizr.js'
          'bower_components/handlebars/handlebars.js'
          'bower_components/underscore/underscore.js'
          'bower_components/underscore.string/dist/underscore.string.min.js'
        ]
        dest: 'public/js/dist/vinch.js'
      }
      foodportal: {
        src: [
          'bower_components/angular/angular.js'
          'bower_components/ui-router/release/angular-ui-router.js'
        ]
        dest: 'public/js/dist/foodportal.js'
      }
    }
    uglify: {
      options: {
        report: 'min'
      }
      vinch: {
        files: {
          'public/js/dist/vinch.min.js': ['public/js/dist/vinch.js']
        }
      }
      foodportal: {
        files: {
          'public/js/dist/foodportal.min.js': ['public/js/dist/foodportal.js']
        }
      }
    }
  }

  project = grunt.option('project') || 'vinch'

  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.registerTask 'components', ['concat:' + project, 'uglify:' + project]