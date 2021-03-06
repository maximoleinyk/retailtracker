module.exports = (grunt) ->
  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')

    clean:
      dist: 'build'
      temp: 'temp'

    eslint:
      target:
        src: [
          'src/client/js/app',
          'src/client/js/util'
        ]
      options:
        config: 'eslint.json'

    less:
      compile:
        options:
          sourceMap: true
          sourceMapFilename: "src/client/css/main.css.map"
          sourceMapBasepath: "src/client/css"
          cleancss: true
          modifyVars:
            'img-path': '"../img"'
            'icon-font-path': '"../fonts/"'
            'fa-font-path': '"../fonts/"'
        files:
          'src/client/css/main.css': 'src/client/css/main.less'

    coffee:
      compile:
        expand: true
        flatten: false
        ext: '.js'
        src: 'temp/js/app/**/*.coffee'

    watch:
      coffee:
        files: ['src/client/js/app/**/*.coffee']
        tasks: ['coffee']
        options:
          spawn: false
          livereload: true
      less:
        files: ['src/client/css/**/*.less']
        tasks: ['less']
        options:
          livereload: true

    copy:
      index:
        files: [
          {
            expand: true
            src: 'index.html'
            cwd: 'temp'
            dest: 'build/client'
          }
        ]
      temp:
        files: [
          {
            expand: true
            src: ['**']
            cwd: 'src/client'
            dest: 'temp'
          }
        ]
      css:
        files: [
          {
            expand: true
            src: ['**']
            cwd: 'src/client/img'
            dest: 'build/client/img'
          }
          {
            expand: true
            src: ['**']
            cwd: 'src/client/fonts'
            dest: 'build/client/fonts'
          }
          {
            expand: true
            src: ['**/main.css']
            cwd: 'src/client/css'
            dest: 'build/client/css'
          }
        ]
      js:
        files: [
          {
            expand: true
            src: ['**/require.js']
            cwd: 'temp/built/js/libs/requirejs'
            dest: 'build/client/js'
          },
          {
            expand: true
            src: ['**/config.js']
            cwd: 'temp/built/js'
            dest: 'build/client/js/app'
          },
          {
            expand: true
            src: [
              '**/account/main.js'
            ]
            cwd: 'temp/built/js/app'
            dest: 'build/client/js/app'
          },
          {
            expand: true
            src: [
              '**/brand/main.js'
            ]
            cwd: 'temp/built/js/app'
            dest: 'build/client/js/app'
          },
          {
            expand: true
            src: [
              '**/company/main.js'
            ]
            cwd: 'temp/built/js/app'
            dest: 'build/client/js/app'
          },
          {
            expand: true
            src: [
              '**/pos/main.js'
            ]
            cwd: 'temp/built/js/app'
            dest: 'build/client/js/app'
          }
        ]

    replace:
      cs:
        src: ['temp/js/app/**/*.js', 'temp/js/config.js']
        overwrite: true
        replacements: [
          {
            from: /'cs!/gi
            to: '\''
          }
        ]
      html:
        src: 'temp/index.html'
        dest: 'temp/index.html'
        replacements: [
          {
            from: '/js/libs/requirejs/require.js'
            to: '/js/require.js'
          }
          {
            from: 'data-main="/static/js/config"'
            to: 'data-main="/static/js/app/config"'
          }
        ]

    requirejs:
      app:
        options:
          appDir: 'temp/js'
          baseUrl: './'
          dir: 'temp/built/js/'
          mainConfigFile: 'temp/js/config.js'
          optimize: 'none'
          fileExclusionRegExp: /\.css/
          findNestedDependencies: true
          modules: [
            {
              name: 'config'
            },
            {
              name: 'app/account/main',
              exclude: ['config']
            },
            {
              name: 'app/brand/main'
              exclude: ['config']
            },
            {
              name: 'app/company/main'
              exclude: ['config']
            }
            {
              name: 'app/pos/main'
              exclude: ['config']
            }
          ]

    uglify:
      compile:
        files:
          'build/client/js/require.js': 'build/client/js/require.js'
          'build/client/js/app/config.js': 'build/client/js/app/config.js'
          'build/client/js/app/account/main.js': 'build/client/js/app/account/main.js'
          'build/client/js/app/brand/main.js': 'build/client/js/app/brand/main.js'
          'build/client/js/app/company/main.js': 'build/client/js/app/company/main.js'
          'build/client/js/app/pos/main.js': 'build/client/js/app/pos/main.js'

    mochaTest:
      test:
        options:
          reporter: 'spec'
        src: ['test/**/*.js']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-text-replace'
  grunt.loadNpmTasks 'grunt-eslint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'test', ['mochaTest']
  grunt.registerTask 'lint', ['eslint']
  grunt.registerTask 'validate', ['lint', 'test']
  grunt.registerTask 'build', ['copy:temp', 'coffee', 'less', 'replace', 'requirejs']
  grunt.registerTask 'dist', ['copy:index', 'copy:css', 'copy:js']
  grunt.registerTask 'optimize', ['clean:temp', 'uglify']

  grunt.registerTask 'default', ['clean', 'validate', 'build', 'dist', 'optimize']
