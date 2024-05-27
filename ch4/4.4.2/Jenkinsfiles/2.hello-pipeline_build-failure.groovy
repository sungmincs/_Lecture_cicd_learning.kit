pipeline {
    agent any
    stages{
        stage('Run Test') {
            steps {
                echo "Let's run a test"
            }
        }
        stage('Build Image') {
            steps {
                script {
                    try {
                        echo "Let's build the image"
                        exit 1
                    }
                    catch (all) {
                        echo "Oops, something went wrong with this build.."
                        currentBuild.result='FAILURE'
                    }
                }
            }
        }
        stage('Deploy Image') {
            steps {
                echo "Let's deploy the image"
            }
        }
    }
}
