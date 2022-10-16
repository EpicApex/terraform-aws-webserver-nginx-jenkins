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
        stage('Update webserver upon changes') {
            script {
                dir('/exercise/terraform-aws-webserver-nginx-jenkins'){
                    sh """
                        echo "WELCOME WORLD"
                        kubectl get nodes
                    """
                }
            }
        }
    }catch(Exception ex) {
        println(ex.toString())
    }
}