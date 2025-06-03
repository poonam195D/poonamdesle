SA_NAME=jenkins-sa
NAMESPACE=env
SECRET_NAME=jenkins-sa-token

# Get values
TOKEN=$(kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath='{.data.token}' | base64 -d)
CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')
CLUSTER_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CA_DATA=$(kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath='{.data.ca\.crt}')

# Create kubeconfig
cat <<EOF > kubeconfig1-jenkins
apiVersion: v1
kind: Config
clusters:
- name: $CLUSTER_NAME
  cluster:
    server: $CLUSTER_SERVER
    certificate-authority-data: $CA_DATA
users:
- name: jenkins-user
  user:
    token: $TOKEN
contexts:
- name: jenkins-context
  context:
    cluster: $CLUSTER_NAME
    user: jenkins-user
current-context: jenkins-context
EOF
