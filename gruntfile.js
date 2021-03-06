module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    cssmin: {
      combine: {
        files: {
          'out/styles/all.min.css': [
            'out/vendor/pure-min.css',
            'out/vendor/font-awesome.min.css',
            'out/vendor/highlight-tomorrow-night.css',
            'out/styles/post-tags.css',
            'out/styles/search.css',
            'out/styles/style.css'
          ]
        }
      }
    },
    clean : {
      combinedCss : {
        src : [ 
          'out/vendor/pure-min.css',          
          'out/vendor/font-awesome.min.css',
          'out/vendor/highlight-tomorrow-night.css',
          'out/styles/post-tags.css',
          'out/styles/style.css'
        ]
      }
    },
    compress: {
      main: {
        options: {
          mode: 'gzip'
        },
        expand: true,
        cwd: 'out/',
        src: ['**/*'],
        dest: 'gzip/',
        ext: ''
      }
    },

    aws: grunt.file.readJSON('aws-keys.json'), // Read the file
    aws_s3_files: [
      {expand: true, cwd: 'gzip', src: ['**/*.html'], dest: '', params: {CacheControl: 'max-age=0'}},
      {expand: true, cwd: 'gzip', src: ['**/*.css','**/*.js'], dest: '', params: {CacheControl: 'max-age=7200'}},
      {expand: true, cwd: 'gzip', src: ['**/*.xml','**/*.xsl'], dest: '', params: {CacheControl: 'max-age=0'}},
      {expand: true, cwd: 'gzip', src: ['**/*'], dest: '', params: {CacheControl: 'max-age=86400'}},
    ],
    aws_s3: {
      options: {
        accessKeyId: '<%= aws.AWSAccessKeyId %>', // Use the variables
        secretAccessKey: '<%= aws.AWSSecretKey %>', // You can also use env variables
        region: 'us-east-1',
        concurrency: 5,
        params: {
            ContentEncoding: 'gzip',
            CacheControl: 'max-age=7200'
        }
      },
      production: {
        options: {
          bucket: 'troykershaw.com'
        },
        files: '<%= aws_s3_files %>'
      },
      staging: {
        options: {
          bucket: 'troykershaw.com-staging'                    
        },
        files: '<%= aws_s3_files %>'
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-compress');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-aws-s3');

  grunt.registerTask('build', ['cssmin']);
  grunt.registerTask('deploy-staging', ['clean','compress','aws_s3:staging']);
  grunt.registerTask('deploy-prod', ['clean','compress','aws_s3:production']);

};