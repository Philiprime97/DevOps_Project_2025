def build = env.BUILD_NUMBER
def appname = "aws"
def harborUrl = "192.168.1.238:8082"
def harborProject = "devops"
def appimage = "${harborUrl}/${harborProject}/${appname}"
def apptag = "${build}"

podTemplate(
    containers: [
        containerTemplate(
            name: 'jnlp',
            image: 'jenkins/inbound-agent',
            ttyEnabled: true
        ),
        containerTemplate(
            name: 'kaniko',
            image: 'gcr.io/kaniko-project/executor:v1.23.0-debug',
            command: '/busybox/cat',
            ttyEnabled: true
        )
    ]
) {
    node(POD_LABEL) {

        stage('Checkout Code') {
            container('jnlp') {
                checkout scm
            }
        }

        stage('Build & Push Docker Image') {
            container('kaniko') {
                withCredentials([usernamePassword(credentialsId: 'harbor-credentials', usernameVariable: 'HARBOR_USER', passwordVariable: 'HARBOR_PASS')]) {
                    sh '''
                    mkdir -p /kaniko/.docker
                    cat <<EOF > /kaniko/.docker/config.json
                    {
                        "auths": {
                            "'"${harborUrl}"'": {
                                "username": "'"${HARBOR_USER}"'",
                                "password": "'"${HARBOR_PASS}"'"
                            }
                        }
                    }
                    EOF

                    /kaniko/executor \\
                        --context=dir://${env.WORKSPACE}/docker \\
                        --dockerfile=${env.WORKSPACE}/docker/Dockerfile \\
                        --destination=${appimage}:${apptag} \\
                        --force
                    """
                }
            }
        }
    }
}
