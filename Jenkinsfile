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
    string(name: 'build', description: 'Appcast build number', defaultValue: '')
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
    stage('Params Example') {
      steps {
        echo "Hello ${params.PERSON}"
        echo "Biography: ${params.BIOGRAPHY}"
        echo "Toggle: ${params.TOGGLE}"
        echo "Choice: ${params.CHOICE}"
        echo "Password: ${params.PASSWORD}"
        echo "build: ${params.build}"
      }
    }
    stage('branch name') {
      when {
        expression { (env.BRANCH_NAME == null) }
      }
      steps {
        echo "env.BRANCH_NAME is ${env.BRANCH_NAME}"
        // will echo "branch name is null"
      }
    }
    stage('params.build to Integer expression') {
      when {
        expression { params.build.toInteger() > 0 }
      }
      steps {
        echo "params.build is greater than 0, toxeek acme."
      }
    }
    stage('sh within script block') {
      steps {
        script {
          String version
          int build
          
          if (env.BRANCH_NAME ==~ /^(hotfix|release)\/.+/) {
            version = env.BRANCH_NAME.replaceAll(/.+\/v(?=[0-9.]+)/,'')
          } else if (env.BRANCH_NAME == null) { // else if (env.BRANCH_NAME == 'develop') {
            version = '99.99.99'
            echo "version is ${version}"
          } else {
            error("bad version")
            // this will make the pipeline error
          }
          echo "params.build is ${params.build}"
          try {
            build = params.build.toInteger()
          } catch (err) {
            error("bad build")
            // this will make the pipeline error
          }

          if (build > 0) {
            sh """
            echo "running sh within script block"
            echo "${params.build} is the params.build"
            """
          }
          else {
            sh """
            echo "build param is not greater than 0"
            echo "ending stage"
            """
            currentBuild.result  = 'UNSTABLE'
          }
        }
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

