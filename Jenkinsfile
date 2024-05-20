releaseBranch = null


pipeline {
  agent any
  tools {
    maven 'MAVEN'
  }
  environment {
    THIS_PIPELINE = "test-pipeline"
    THIS_TEST = "pipeline-test"
    FOO = credentials("cddb9cfb-06ed-417a-8631-11e126687840")
    JOB_TIME = sh(returnStdout: true, script: "date '+%A %W %Y %X'").trim()
    REPOSITORY_OWNER = "toxeek"
    REPOSITORY_NAME = "sysadmin-stuff"
    
  }
  parameters {
    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
    text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')
    booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')
    choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')
    password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
    string(name: 'build', description: 'Appcast build number', defaultValue: '')
  }
  options {
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '10', numToKeepStr: '20'))
    timestamps()
    disableConcurrentBuilds()
    //retry(3)
    timeout time:10, unit:'MINUTES'
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
        echo "job time: ${env.JOB_TIME}"
        sh 'mvn -version'
        echo "echoing current build number .."
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
        script {
          if (isReleaseBranch()) {
            echo "isReleaseBranch branch is ${releaseBranch}"
          }
        }
      }
      post {
        success {
          echo "Stage successfully finished"
        }
      }
    }
    stage('Build and Push Release') {
      when {
        branch 'master'
      }
      steps {
                // auto upgrade demo env
        echo 'auto upgrades not yet implemented'
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
        echo "env.WORKSPACE is ${env.WORKSPACE}"
        // will echo "env.BRANCH_NAME is null" as this is not a multibranch pipeline
		    script {
		      env.START_DATE = sh (
			      script: 'date +%Y-%m-%d',
			      returnStdout: true
		      ).trim()

		      env.START_DAY = sh (
			      script: 'date +%A',
			      returnStdout: true
		      ).trim()
        }
      }
    }
    stage('params.build to Integer expression') {
      when {
        expression { params.build.toInteger() > 0 }
      }
      steps {
        echo "params.build is greater than 0, toxeek acme."
        echo "env.START_DAY is ${env.START_DAY}"
          script {
            if (env.CHANGE_ID != null) {
              // env.CHANGE_ID won't be null for PRs

              def installFiles = ['stripes-install.json',
                                  'okapi-install.json',
                                  'install.json',
                                  'yarn.lock']
              for (int i = 0; i < installFiles.size(); i++) {
                sh "git add ${env.WORKSPACE}/${installFiles[i]}"
              }
              def json = sh (script: "curl -s https://api.github.com/repos/${REPOSITORY_OWNER}/${REPOSITORY_NAME}/pulls/${env.CHANGE_ID}", returnStdout: true).trim()
              def body = evaluateJson(json,'${json.body}')
              echo "getting PR json"
              if (body.contains("[skip ci]")) {
                echo ("'[skip ci]' spotted in PR body text.")
                env.shouldBuild = "false"
              }
            }
            else if (env.CHANGE_ID == null) {
              def jenkins = sh(returnStdout: true, script: "pwd").trim()
              echo "jenkins path is: ${jenkins}"
              if (jenkins.contains("jenkins")) {
                echo "jenkins found in path"
              }
            }
         }
      }
    }
    stage('Build'){
      when {
        expression {
          return env.shouldBuild != "false"
          // env.shouldBuild is null, and not defined can not be printed
        }
      }
      steps {
        sh "echo env.CHANGE_ID is ${env.CHANGE_ID}, and we do not skip ci"
        sh 'echo "FOO login is $FOO_USR"'
      }
      // post {
      //  always {
      //   archiveArtifacts "_output/lint/**/*"
      //  }
      // }
    }
    stage("Publish coverage to Codecov") {
      when {
        expression { env.BRANCH_NAME != null }
      }
      steps {
        script {
          sh 'curl -s https://codecov.io/bash | bash -s -- -c -f _output/tests/**/coverage.txt -F unittests'
        }
      }
    }
    stage('sh within script block') {
      steps {
        script {
          String version
          int build
          def output = sh(returnStdout: true, script: 'pwd')
          echo "Output: ${output}"
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
    stage('publish') {
			when {
			  anyOf {
					branch 'develop'
					branch 'master'
				}
			}
      steps {
        withDockerRegistry([
          credentialsId: "oa-sa-jenkins-registry",
          url: "https://registry.openanalytics.eu"]) {
            sh "docker push registry.openanalytics.eu/${env.NS}/rdepot-${MODULE}:${env.VERSION}"
            sh "docker push registry.openanalytics.eu/${env.NS}/rdepot-${MODULE}:latest"
        }
      }
    }
     /*
    stage('Ubuntu jammy packaging') {
      when {
        beforeAgent true
        expression { return fileExists('src/packages/docker/deb-jammy/Dockerfile') }
        anyOf {
          changeset "src/**"
          changeset "Jenkinsfile"
        }
      }
      agent {
        dockerfile {
          dir 'src/packages/docker/deb-jammy'
          args '-v /etc/passwd:/etc/passwd:ro -v /etc/group:/etc/group:ro -e HOME=/tmp'
          reuseNode true
        }
      }
      steps {
        script {
          sh './src/packages/build-deb.sh jammy'
        }
      }
    } */
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
    unstable {
      echo "things got messed up"
    }
  }
}
@NonCPS
def evaluateJson(String json, String gpath){
    // parse json
    def ojson = new groovy.json.JsonSlurper().parseText(json)
    // evaluate gpath as a gstring template where $json is a parsed json parameter
    return new groovy.text.GStringTemplateEngine().createTemplate(gpath).make(json:ojson).toString()
}

def isReleaseBranch() {
    return (env.BRANCH_NAME == releaseBranch)
}