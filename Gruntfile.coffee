#!
# egemswatch
# Boostrap theme based on Paper by Bootswatch.
# @version 3.2.0 - 2014-09-22
# @link http://egemsoft.github.io/egemswatch
# @license MIT, http://opensource.org/licenses/MIT
#

module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-chmod'


  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      app:
        files:
          'bin/kamuran': 'src/kamuran.coffee'
        options:
          bare: true

    chmod:
      options:
        mode: '755'
      bin:
        src: 'bin/kamuran'

  grunt.registerTask 'addNodeEnv', ->
    bin = grunt.file.read('bin/kamuran')
    grunt.file.write 'bin/kamuran', '#!/usr/bin/env node\n' + bin

  grunt.registerTask 'build', [
    'coffee'
    'chmod'
    'addNodeEnv'
  ]

  grunt.registerTask 'default', [
      'build'
    ]