pipeline {
  agent any
  environment {
    THIS_PIPELINE = "test-pipeline"
    THIS_TEST = "pipeline-test"
    FOO = credentials("cddb9cfb-06ed-417a-8631-11e126687840")
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
        sh "echo ${MY_PROJECT} to ${env.S3_BUCKET}"
        echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
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
    stage ('another when expression') {
      when { expression { env.THIS_TEST == "pipeline-test" }}
      steps {
        echo "this pipeline is ${THIS_TEST}"
      }
    }
    stage('foo') {
      sh 'echo "FOO IS $FOO"'
      sh 'echo "FOO_USR is $FOO_USR"'
      sh 'echo "FOO_PSW IS $FOO_PSW"'
    }
  post {
    always {
      deleteDir() /* clean up our workspace */
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

