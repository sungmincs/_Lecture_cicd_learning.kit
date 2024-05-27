pipeline {
    agent any
    environment {
        MY_NAME = 'Jenkins the builder'
    }
    stages{
        stage('Hello Jenkins') {
            steps {
                sh 'echo "My name is ${MY_NAME}, and this name is from my global environment variable"'
            }
        }
        stage('Nice to meet you') {
            environment {
                WHAT_I_LOVE = 'learning CI/CD with Jenkins pipeline'
            }
            steps {
                sh 'echo "I love ${WHAT_I_LOVE}!, and this is from stage environment variable!"'
            }
        }
    }
    post {
        always {
            echo "See you soon again, ${MY_NAME}!"
        }
    }
}

