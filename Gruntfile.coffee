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
          'bower_components/oauth-signature/dist/oauth-signature.js'
        ]
        dest: 'public/js/dist/foodportal.js'
      }
    }
    ngAnnotate: {
      options: {
        singleQuotes: true
      }
      foodportal: {
        files: {
          'public/js/dist/foodportal.js': ['public/js/dist/foodportal.js']
        }
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

  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-ng-annotate'

  grunt.registerTask 'vinch', ['concat:vinch', 'uglify:vinch']
  grunt.registerTask 'foodportal', ['concat:foodportal', 'ngAnnotate:foodportal', 'uglify:foodportal']