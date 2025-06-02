releaseBranch = null
def app


pipeline {
  agent {node {label 'linux'}}
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
  /*
  parameters {
    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
    text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')
    booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')
    choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')
    password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
    string(name: 'build', description: 'Appcast build number', defaultValue: '')
  }
  */
  options {
    // Only keep the 10 most recent builds
    buildDiscarder(logRotator(numToKeepStr:'10'))
    timestamps()
    disableConcurrentBuilds()
    // skipDefaultCheckout true
    //retry(3)
    timeout time:40, unit:'MINUTES'
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
    stage('OWASP Dependency-Check Vulnerabilities') {
      steps {
        dependencyCheck additionalArguments: ''' 
                    -o './'
                    -s './'
                    -f 'ALL' 
                    --prettyPrint''', odcInstallation: 'OWASP dependency check'
        
        dependencyCheckPublisher failedTotalCritical: 1, pattern: 'dependency-check-report.xml', stopBuild: true
      }
    }
    stage('Build and Push Release') {
      when {
        branch 'dev'
      }
      environment {
        GIT_SHA1 = sh(returnStdout: true, script: 'git rev-parse --short HEAD')
      }
      steps {
                // auto upgrade demo env
        echo "env.GIT_COMMIT: ${env.GIT_COMMIT[0..6]}"
        echo "env.GIT_SHA1: ${GIT_SHA1}"
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
    stage('agent docker node') {
      agent {
        docker {
          image 'node:16-alpine'
          // args '-u 0'
          label 'linux-vm'
        }
      }
      steps {
        sh 'node --version'
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
    /*
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
    */
    stage('branch name') {
      when {
        expression { (env.BRANCH_NAME == 'dev') }
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
    /*
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
    } */
    // hadolint doesn't need a plugin, just installed in the worker
    stage("Hadolint") {
      steps {
        // sh 'hadolint dockerfiles/* | tee -a hadolint_lint.txt'
        sh "mkdir hadolint"
        sh "NO_COLOR=1 hadolint Dockerfile --no-fail | tee -a hadolint/hadolint.log"
        sh "cat hadolint/hadolint.log"
      }
    }
    stage('Build and Push'){
      when {
        expression {
          return env.shouldBuild != "false"
          // env.shouldBuild is null, and not defined can not be printed
        }
      }
      steps {
        sh "echo env.CHANGE_ID is ${env.CHANGE_ID}, and we do not skip ci"
        sh 'echo "FOO login is $FOO_USR"'
        // for the next, I need to install the Docker Pipeline Plugin
        // https://plugins.jenkins.io/docker-workflow/
        script {
          app = docker.build("toxeek/test")
          docker.withRegistry('https://registry.hub.docker.com', 'docker-private-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
          }
          echo "docker build finished"
        }
      }
      // post {
      //  always {
      //   archiveArtifacts "_output/lint/**/*"
      //  }
      // }
    }
    // trivy doesn't need a plugin, just installed in the worker
    stage('Scan Docker Image') {
        steps {
            sh "mkdir trivy"
            script {
                // Run Trivy to scan the Docker image
                def trivyOutput = sh(script: "trivy image toxeek/test:latest -f json", returnStdout: true).trim()

                // Display Trivy scan results
                // println trivyOutput
                writeFile file: "trivy/trivy.log", text: trivyOutput

                // Check if vulnerabilities were found
                if (trivyOutput.contains("Total: 0")) {
                    echo "No vulnerabilities found in the Docker image."
                } else {
                    echo "Vulnerabilities found in the Docker image."
                    // You can take further actions here based on your requirements
                    // For example, failing the build if vulnerabilities are found
                    // error "Vulnerabilities found in the Docker image."
                }
            }
        }
    }
    stage("Parallel docker build & sonar-scanner") {
        when { 
           expression { env.BRANCH_NAME == 'master' }
        }
        parallel {
        // PRs are going to be against dev or master so we just check the PR id
        // parallel build simulating the bitbucket-pipelines.yml one
            stage("Build and Push Docker to AWS registry") {
                agent {
                        label 'docker'
                }
                steps {
                    // regions and also credentials per account may need changing
                    // this needs the plugin https://plugins.jenkins.io/pipeline-aws/
                    withAWS(credentials: 'AWS-TASKS-ACCESS', region: 'us-east-1') {
                        sh "curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o awscli-bundle.zip"
                        sh "unzip -o awscli-bundle.zip"
                        sh "./awscli-bundle/install -b ~/bin/aws"
                        sh "export PATH=~/bin:\$PATH"
                        sh 'eval \$(aws ecr get-login --no-include-email --region us-east-1)'
                        sh "docker build -t ${env.IMAGE_NAME_VERSION} ."
                        sh "docker push ${env.IMAGE_NAME_VERSION} && docker rmi ${env.IMAGE_NAME_VERSION}"
                    }
                }
            }
            // SonarQube scanner tool - running in the npm agent node
            stage("SonarQube Scanner") {
                agent {
                        label 'docker'
                }
                environment {
                    SCANNER_HOME = tool 'SonarCloudOne'
                    ORGANIZATION = "hyperjar"
                    PROJECT_NAME = "hyperjar-bacoffice-fe"
                    SONAR_LOGIN = "jose-hyperjar@bitbucket"
                }
                steps {
                    // sonarQube needs installed ..
                    withSonarQubeEnv('SonarCloudOne') { 
                        sh '''
                        sonar-scanner -Dsonar.organization=\$ORGANIZATION \
                        -Dsonar.inclusions=**/*.js \
                        -D.projectName=\$PROJECT_NAME \
                        -D.sonar.login=\$SONAR_LOGIN \
                        -Dsonar.projectKey=finovertech_hyperjar-back-office-fe'''
                    }
                }
            }
        }
    }
    stage("Sonarqube Scan") {
      when {
        branch 'dev'
      }
      steps{
        withSonarQubeEnv(installationName: 'sq1') {
          sh "./mvnw clean org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar"
        }
      }
    }
    // if the pipeline fails the  quality gate stage with PENDING, go to the sonarqube dashboard, Administration > Configuration > Webhooks,
    // and see the Last Modified message. If it says SERVER UNREACHABLE, try to exec into the container (if sonarqube runs in a container):
    // docker exec -it -u 0 sonarqube bash
    // and install curl and curl the jenkins webhook url (e.g.: http://192.168.1.103:8080/sonarqube-webhook/), see what happens
    // If the container host/machine is running ubuntu and ufw is enabled, make sure I allow 8080 on ufw: (this solved my issue)
    // sudo ufw status
    // sudo ufw allow 8080
    stage("Sonarqube QualityGate") {
      when {
       branch 'dev'
      }
      steps {
        timeout(time: 2, unit: 'MINUTES') {
        waitForQualityGate abortPipeline: true
        }
      }
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
          } else if (env.BRANCH_NAME == 'dev') { 
            version = '99.99.99'
            echo "version is ${version}"
          } else {
            error("bad version")
            // this will make the pipeline error
          }
          /*
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
        */
        }
      }
    }
    stage('publish') {
			when {
			  anyOf {
					branch 'develop'
					branch 'master'
				}
      // when { expression { env.BRANCH_NAME == "master" || env.BRANCH_NAME == "develop "}}
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
      // archiveArtifacts artifacts: 'hadolint/*.log', allowEmptyArchive: true
      archiveArtifacts artifacts: '**/*.log', allowEmptyArchive: true
      deleteDir() /* clean up our workspace */
      // archiveArtifacts artifacts: '**/*.log, **/*.layout'
    }
        // if build was successful
    success {
      echo "PIPELINE SUCCEEDED"
      /*
      script {
				slackSend(color: 'green', message: "Result: ${currentBuild.currentResult} | Build# ${env.BUILD_URL}", channel: "#jenkins-alerts-teamx")
      }
      */
        // if build failed
    }
    failure {
      echo "BIG FAIL!"
      /*
      script {
				slackSend(color: 'red', message: "Result: ${currentBuild.currentResult} | Build# ${env.BUILD_URL}", channel: "#jenkins-alerts-teamx")
      }
      */
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


def waitForAllPodsRunning(String namespace) {
    timeout(KUBERNETES_RESOURCE_INIT_TIMEOUT) {
        while (true) {
            podsStatus = sh(returnStdout: true, script: "kubectl --namespace='${namespace}' get pods --no-headers").trim()
            def notRunning = podsStatus.readLines().findAll { line -> !line.contains('Running') }
            if (notRunning.isEmpty()) {
                echo 'All pods are running'
                break
            }
            sh "kubectl --namespace='${namespace}' get pods"
            sleep 10
        }
    }
}

def waitForAllServicesRunning(String namespace) {
    timeout(KUBERNETES_RESOURCE_INIT_TIMEOUT) {
        while (true) {
            servicesStatus = sh(returnStdout: true, script: "kubectl --namespace='${namespace}' get services --no-headers").trim()
            def notRunning = servicesStatus.readLines().findAll { line -> line.contains('pending') }
            if (notRunning.isEmpty()) {
                echo 'All pods are running'
                break
            }
            sh "kubectl --namespace='${namespace}' get services"
            sleep 10
        }
    }
}