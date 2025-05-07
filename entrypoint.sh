#entrypoint.sh

#!/bin/bash

# These variables should be passed in as environment variables
# JENKINS_URL, JENKINS_AGENT_NAME, JENKINS_SECRET

#if [[ -z "$JENKINS_URL" || -z "$JENKINS_AGENT_NAME" || -z "$JENKINS_SECRET" ]]; then
#  echo "Missing one or more required environment variables."
#  echo "Required: JENKINS_URL, JENKINS_AGENT_NAME, JENKINS_SECRET"
#  exit 1
#fi

echo "Starting Jenkins agent..."
curl -sO https://jenkinsk8s.ecdevops.net/jnlpJars/agent.jar
java -jar agent.jar -url http://jenkins.default.svc.cluster.local:8080 -secret "$JENKINS_SECRET" -name "$JENKINS_NAME"   -workDir "/home/jenkins/agent"
# start docker daemon
#dockerd &
# optionally wait for the daemon to be ready
#docker info
#exec "$@"
# Start Docker daemon in the background
dockerd > /var/log/dockerd.log 2>&1 &

# Wait for Docker daemon to be ready (optional but recommended)
while(! docker info > /dev/null 2>&1); do
  echo "Waiting for Docker daemon to start..."
  sleep 1
done

echo "Docker is ready!"
