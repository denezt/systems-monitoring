pipeline {
    agent any
    options {
        ansiColor('xterm')
    }

    stages {
    
        stage('Prechecks') {
            when {
                expression {
                    // Check if the job name ends with '_check'
                    return env.JOB_NAME.endsWith('_check')
                }
            }
            steps {
                echo "==================[ Running Prechecks ]=================="
                echo 'Starting, Prechecks...'
                echo 'Checking for Make version.'
                sh 'make --version'
                echo 'Checking for GCC version.'
                sh 'gcc --version'
            }
        }
		
        stage('Initial Setup'){
            when {
                expression {
                    return env.JOB_NAME.endsWith('_test')
                }
            }
            steps {
                echo "==================[ Starting Initial Setup ]=================="
                sh 'sudo chmod -R a+x ./scripts'
                sh './setup.sh --create'
                sh 'make clean compile'
            }
        }
        stage('Agent Testing') {
            when {
                expression {
                    return env.JOB_NAME.endsWith('_test')
                }
            }
            steps {
                echo "==================[ Testing Agent ]=================="
                echo 'Testing...'
            }
        }
        stage('Monitoring') {
            when {
                expression {
                    return env.JOB_NAME.endsWith('_test')
                }
            }
            steps {
                echo "==================[ Starting Monitoring ]=================="            
                echo 'Monitoring...'
                sh 'make test'
            }
        }
    }
}
