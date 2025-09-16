pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Prepare') {
      steps {
        sh '''
          chmod +x app/greet.sh tests/test_greet.sh || true
          mkdir -p dist
        '''
      }
    }

    stage('Test') {
      steps {
        sh '''
          echo "Running tests..."
          ./tests/test_greet.sh
        '''
      }
    }

    stage('Package') {
      steps {
        sh '''
          echo "Packaging artifact..."
          TIMESTAMP=$(date +%Y%m%d%H%M%S)
          ART=dist/hello-ci-mini-${TIMESTAMP}.tar.gz
          tar -czf "${ART}" app README.md
          echo "Created ${ART}"
          ls -l dist || true
        '''
      }
    }

    stage('Archive artifact') {
      steps {
        archiveArtifacts artifacts: 'dist/**', fingerprint: true
      }
    }

    stage('Upload to Nexus (raw)') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'nexus-http-creds', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PW')]) {
          sh '''
            set -eux
            NEXUS_BASE="http://hnexus.vyturr.one:8081/repository/raw-hosted"
            REMOTE_DIR="ci-artifacts/${BUILD_NUMBER}"
            for f in dist/*; do
              echo "Uploading $f to ${NEXUS_BASE}/${REMOTE_DIR}/$(basename $f)"
              curl -u "${NEXUS_USER}:${NEXUS_PW}" --fail --show-error --upload-file "$f" \
                "${NEXUS_BASE}/${REMOTE_DIR}/$(basename $f)"
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
 
