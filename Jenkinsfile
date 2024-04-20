pipeline {
  agent any
  stages {
    stage("echo build number") {
      when {
        expression {
          currentBuild.getNumber() % 2 == 1
        }
      }        
      steps {
        echo "echoing build number .."
        echo "${currentBuild.number}"
        sh "echo current build id ${currentBuild.id}"
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

