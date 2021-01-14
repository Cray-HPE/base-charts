@Library('dst-shared@master') _

pipeline {

  agent { node { label 'dstbuild' } }

  environment {
    PRODUCT = 'csm'
    RELEASE_TAG = setReleaseTag()
  }

  stages {

    stage('Package') {
      steps {
        packageHelmCharts(chartsPath: "${env.WORKSPACE}/stable",
                          buildResultsPath: "${env.WORKSPACE}/build/results",
                          buildDate: "${env.BUILD_DATE}")
      }
    }

    stage('Publish') {
      steps {
        publishHelmCharts(chartsPath: "${env.WORKSPACE}/stable")
      }
    }

  }

  post {
    success {
      findAndTransferArtifacts()
    }
  }

}
