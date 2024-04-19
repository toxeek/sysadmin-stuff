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
      }
    }
  }
}

