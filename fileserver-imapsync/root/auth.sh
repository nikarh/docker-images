#!/bin/sh

set -o allexport
. /run/secrets/IMAP_AUTH
set +o allexport

# Either return username from the secret
if [ "$1" = "username" ]; then
    echo "$USERNAME"
    exit
fi

# Or generate a new access token using a refresh token. When that fails, only Google's
# error goes to stderr and nothing to stdout, so no "null" is sent to Gmail as a token.
response="$(curl -s https://oauth2.googleapis.com/token \
    --data-urlencode "client_id=$CLIENT_ID" \
    --data-urlencode "client_secret=$CLIENT_SECRET" \
    --data-urlencode "refresh_token=$REFRESH_TOKEN" \
    --data-urlencode "grant_type=refresh_token")"
token="$(echo "$response" | jq -r '.access_token // empty' 2> /dev/null)"
if [ -z "$token" ]; then
    msg="$(echo "$response" | jq -r '"\(.error) \(.error_description // "")"' 2> /dev/null)" \
        || msg="no JSON answer"
    echo "token refresh failed: $msg" >&2
    exit 1
fi
echo "$token"
