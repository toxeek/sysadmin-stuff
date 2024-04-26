pipeline {
  agent any
  environment {
    THIS_PIPELINE = "test-pipeline"
    THIS_TEST = "pipeline-test"
    FOO = credentials("cddb9cfb-06ed-417a-8631-11e126687840")
  }
   parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')

        text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')

        booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')

        choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')

        password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
   }
  stages {
    stage("echo build number") {
      when {
        expression {
          currentBuild.getNumber() % 2 == 1 && !(env.BRANCH_NAME =~ /feature/)
          // env.BRANCH_NAME only works in multi branch pipelines, will be set to null here
        }
      }
      environment {
        MY_PROJECT = "sysadmin-stuff"
        S3_BUCKET = "toxeek-bucket"
      }
      steps {
        echo "echoing build number .."
        echo "${currentBuild.number}"
        sh "echo current build id ${currentBuild.id}"
        sh "echo ${MY_PROJECT} to ${env.S3_BUCKET}"
        echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
        // env.BRANCH_NAME only works in multi branch pipelines, will be null
        // echo "building on branch ${env.BRANCH_NAME}" 
        timeout(time: 5, unit: "SECONDS") {
          retry(5) {
            echo "hello world"
          }
        }
      }
      post {
        success {
          echo "Stage successfully finished"
        }
      }
    }
    stage('when expression') { 
      when {
        environment name: 'THIS_PIPELINE', value: 'test-pipeline' 
      }
      steps {
        echo "my project is ${THIS_PIPELINE}"
      }
    }
    stage('another when expression') {
      when { expression { env.THIS_TEST == "pipeline-test" }}
      steps {
        echo "this pipeline is ${THIS_TEST}"
      }
    }
    stage('foo') {
      steps { 
        sh 'echo "FOO is $FOO"'
        sh 'echo "FOO_USR is $FOO_USR"'
        sh 'echo "FOO_PSW is $FOO_PSW"'
      }
    }
    stage('when not branch stage') {
      when {
        not {
          branch 'master'
        }
      }
      steps {
        echo 'we are NOT at the master branch'
      }
    }
    stage('parallel') {
      parallel {
        stage('parallel one') {
          steps {
            echo "parallel one stage"
          }
        }
        stage('parallel two') {
          steps {
            echo 'parallel two stage'
          }
        }
      }
    }
    stage('Example') {
      steps {
        echo "Hello ${params.PERSON}"

        echo "Biography: ${params.BIOGRAPHY}"

        echo "Toggle: ${params.TOGGLE}"

        echo "Choice: ${params.CHOICE}"

        echo "Password: ${params.PASSWORD}"
      }
    }
  } 
  post {
    always {
      deleteDir() /* clean up our workspace */
      // archiveArtifacts artifacts: '**/*.log, **/*.layout'
    }
        // if build was successful
    success {
      echo "PIPELINE SUCCEEDED"
    }
        // if build failed
    failure {
      echo "BIG FAIL!"
    }
  }
}

