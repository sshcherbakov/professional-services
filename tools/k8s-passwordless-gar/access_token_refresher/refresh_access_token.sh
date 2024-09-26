#!/bin/sh

# PROJECT_NUMBER="861675023757"   # Project number of the Google Cloud project where workload identity resources are located
# POOL_ID="k8s-wif"               # The name of the Workload Identity pool
# PROVIDER_ID="k8s-wif-provider"  # The name of the Workload Identity Provider in the Workload Identity Pool
# SERVER_NAME="europe-west3-docker.pkg.dev"   # The Google Artifact Registry API server name (regional in this example)
# USER_NAME="oauth2accesstoken"               # Fixed value representing the username in the Docker credentials

TOKEN=$(cat /var/run/secrets/tokens/oidc-token)

PAYLOAD=$(cat <<EOF
{
  "audience": "//iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/providers/${PROVIDER_ID}",
  "grantType": "urn:ietf:params:oauth:grant-type:token-exchange",
  "requestedTokenType": "urn:ietf:params:oauth:token-type:access_token",
  "scope": "https://www.googleapis.com/auth/cloud-platform",
  "subjectTokenType": "urn:ietf:params:oauth:token-type:jwt",
  "subjectToken": "${TOKEN}"
}
EOF
)

ACCESS_TOKEN=$(curl -X POST "https://sts.googleapis.com/v1/token" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data "${PAYLOAD}" \
  | jq -r '.access_token'
)
AUTH=$(echo -n ${USER_NAME}:${ACCESS_TOKEN} | base64 -w0)

CRED_VALUE="{\"auths\":{\"${SERVER_NAME}\":{\"username\":\"${USER_NAME}\",\"password\":\"${ACCESS_TOKEN}\", \"auth\":\"${AUTH}\"}}}"

kubectl patch secret regcred --type=json --patch="[{\"op\": \"replace\", \"path\": \"/data/.dockerconfigjson\", \"value\": \"$(echo -n ${CRED_VALUE} | base64 -w0)\" }]"

