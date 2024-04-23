pipeline {
  agent any
  environment {
    THIS_PIPELINE = "test-pipeline"
  }
  stages {
    stage("echo build number") {
      when {
        expression {
          currentBuild.getNumber() % 2 == 1
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
        sh "echo ${MY_PROJECT} to ${S3_BUCKET}"
        timeout(time: 5, unit: "SECONDS") {
          retry(5) {
            echo "hello"
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
        echo "my project is ${MY_PROJECT}"
      }
    }
  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
        // if build was successful
    success {
      echo "SUCCEEDED"
    }
        // if build failed
    failure {
      echo "BIG FAIL!"
    }
  }
}

