node('memyselfandi'){
    try 
    {
        stage('Clean-up') {
            sh "rm -rf /exercise/terraform-aws-webserver-nginx-jenkins/"
            sh "mkdir -p /exercise/terraform-aws-webserver-nginx-jenkins/"
        }
        stage('Checkout terraform-aws-webserver-nginx-jenkins') {
            dir('/exercise/terraform-aws-webserver-nginx-jenkins'){
                script {
                    scmvars = checkout scm
                }
            }
        }
        stage('') {
            script {
                dir('/exercise/terraform-aws-webserver-nginx-jenkins'){
                    sh """
                        echo "WELCOME WORLD"
                    """
                }
            }
        }
    }catch(Exception ex) {
        println(ex.toString())
    }
}