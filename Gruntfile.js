module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffeelint: {
      files: ['src/**/*.coffee'],
    },
    watch: {
      files: ['src/**/*.*', '*.*', 'tests/**/*.*'],
      tasks: ['test']
    },
    mochaTest: {
      options: {
        reporter: 'spec',
        require: [
          'coffee-script/register',
          function(){ expect=require('chai').expect; },
          function(){ sinon=require('sinon'); }
        ]
      },
      src: ['tests/**/*-spec.coffee']
    },
    coffee: {
        glob_to_multiple: {
          expand: true,
          flatten: false,
          cwd: 'src/',
          src: ['**/*.coffee'],
          dest: 'dist/',
          ext: '.js'
        }
      },
  });

  require('load-grunt-tasks')(grunt);

  // test
  grunt.registerTask('test', ['coffeelint', 'mochaTest']);
  grunt.registerTask('build', ['coffee']);

  grunt.registerTask('default', ['test', 'build']);
};
