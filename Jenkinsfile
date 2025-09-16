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
          # dummy test: fail if hello.txt missing or empty
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

    stage('Print artifact path') {
      steps {
        sh 'echo "Artifact archived to Jenkins (see Build → Artifacts). Files:" && ls -l build'
      }
    }
  }

  post {
    success { echo "Pipeline succeeded." }
    failure { echo "Pipeline failed — check console output." }
    always { cleanWs() }
  }
}

