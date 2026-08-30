// ch9.6 Jenkins — Trivy Scan stage (Build 다음에 추가)
stage('Trivy Scan') {
    steps {
        sh """
            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
            trivy image --exit-code 1 --severity CRITICAL,HIGH --ignore-unfixed --format table ${DOCKER_REPOSITORY}:${IMAGE_TAG}
        """
    }
}
