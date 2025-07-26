MY_NAME = 'Jenkins the builder'

pipeline {
    agent any
    stages {
        stage('Hello Jenkins') {
            steps {
                echo "My name is ${MY_NAME}, and this name is from my global environment variable"
            }
        }
        stage('Nice to meet you') {
            whatILove = 'learning CI/CD with Jenkins pipeline'
            steps {
                sh 'echo "I love ${whatILove}!, and this is from stage environment variable!"'
            }
        }
    }
    post {
        always {
            echo "See you soon again, ${MY_NAME}!"
        }
    }
}

