pipeline {
    agent any
    stages{
        stage('Run Test') {
            steps {
                echo "Let's run a test"
            }
        }
        stage('Build Image') {
            try {
                echo "Let's build the image"
                exit 1
            }
            catch (exc) {
                echo "Oops, something went wrong with this build.."
                throw
            }
        }
        stage('Deploy Image') {
            steps {
                echo "Let's deploy the image"
            }
        }
    }
}
