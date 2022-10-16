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
                        kubectl delete -n develop statefulset/nginx
                        kubectl apply -n develop -f /exercise/terraform-aws-webserver-nginx-jenkins/webserver-deployment/nginx-statefulset.yml
                        kubectl rollout status -n develop statefulset/nginx -v2
                        kubectl cp /exercise/terraform-aws-webserver-nginx-jenkins/webserver-deployment/index.html develop/nginx-0:/root
                        kubectl exec -n develop pod/nginx-0 -- chmod 611 /root
                    """
                }
            }
        }
    }catch(Exception ex) {
        println(ex.toString())
    }
}
