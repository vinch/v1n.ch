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
      foodportal: {
        src: [
          'bower_components/angular/angular.js'
          'bower_components/ui-router/release/angular-ui-router.js'
          'bower_components/oauth-signature/dist/oauth-signature.js'
          'bower_components/fastclick/lib/fastclick.js'
        ]
        dest: 'public/js/dependencies/foodportal.js'
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
      foodportal: {
        files: {
          'public/js/dependencies/foodportal.min.js': ['public/js/dependencies/foodportal.js']
          'public/js/foodportal.min.js': ['public/js/foodportal.js']
        }
      }
    }

    coffee: {
      compile: {
        expand: true
        flatten: false
        cwd: 'app/assets/js/'
        src: ['foodportal/**/*.coffee']
        dest: 'public/js/'
        ext: '.js'
      }
      join: {
        options: {
          join: true
        }
        files: {
          'public/js/foodportal.js': ['app/assets/js/foodportal/**/*.coffee']
        }
      }
    }

    ngAnnotate: {
      options: {
        singleQuotes: true
      }
      foodportal: {
        files: {
          'public/js/foodportal.js': ['public/js/foodportal.js']
        }
      }
    }

    stylus: {
      compile: {
        files: {
          'public/css/foodportal.css': 'app/assets/css/foodportal/main.styl'
        }
      }
    }

    jade: {
      compile: {
        options: {
          pretty: true
          data: {
            debug: false
          }
        }
        files: {
          'public/html/foodportal/layout.html' : ['app/views/foodportal/layout.jade']
        }
      }
    }

    processhtml: {
      dist: {
        files: {
          'public/html/foodportal/layout.html': ['public/html/foodportal/layout.html']
        }
      }
    }

    watch: {
      coffee: {
        files: ['app/assets/css/foodportal/**/*.styl', 'app/assets/js/foodportal/**/*.coffee']
        tasks: ['coffee:compile', 'stylus']
      }
    }

  }

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-ng-annotate'
  grunt.loadNpmTasks 'grunt-processhtml'

  grunt.registerTask 'dev', ['clean', 'concat:vinch', 'coffee:compile', 'concat:foodportal', 'stylus', 'watch']
  grunt.registerTask 'build', ['concat:vinch', 'uglify:vinch', 'coffee:join', 'concat:foodportal', 'ngAnnotate:foodportal', 'uglify:foodportal', 'stylus', 'jade', 'processhtml']
