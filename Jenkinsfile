pipeline {
  agent any
  stages {
    stage("echo build number") {
      steps {
        echo "echoing build number .."
        echo "${currentBuild.number}"
      }
    }
  }
}

