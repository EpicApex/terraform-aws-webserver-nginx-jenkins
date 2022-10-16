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
                        kubectl exec -n develop pod/nginx-0 -- chmod 611 /root
                        kubectl cp /exercise/terraform-aws-webserver-nginx-jenkins/webserver-deployment/index.html develop/nginx-0:/root
                        kubectl delete -n develop pod/nginx-0
                    """
                }
            }
        }
    }catch(Exception ex) {
        println(ex.toString())
    }
}
