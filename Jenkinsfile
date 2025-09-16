pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Prepare') {
      steps {
        sh '''
          mkdir -p build
          echo "Hello from CI build!" > build/hello.txt
          echo "artifact created at $(date)" > build/metadata.txt
        '''
      }
    }

    stage('Run simple test') {
      steps {
        sh '''
          if [ ! -s build/hello.txt ]; then
            echo "hello.txt missing or empty" >&2
            exit 1
          fi
          echo "simple test OK"
        '''
      }
    }

    stage('Archive artifact') {
      steps {
        archiveArtifacts artifacts: 'build/**', fingerprint: true
      }
    }

    stage('Upload to Nexus (raw)') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'nexus-http-creds', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PW')]) {
          sh '''
            NEXUS_URL="http://hnexus.vyturr.one:8081/repository/raw-hosted"
            BUILD_ID_DIR="ci-artifacts/${BUILD_NUMBER}"

            for f in build/*; do
              echo "Uploading $f ..."
              curl -u "${NEXUS_USER}:${NEXUS_PW}" --upload-file "$f" \
                "${NEXUS_URL}/${BUILD_ID_DIR}/$(basename $f)"
            done
          '''
        }
      }
    }
  }

  post {
    success { echo "Pipeline succeeded." }
    failure { echo "Pipeline failed — check console output." }
    always { cleanWs() }
  }
}

