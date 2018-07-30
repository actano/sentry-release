#!/usr/bin/env bash
set -e

if [[ -n "${PATH_TO_SOURCEMAPS}" ]]; then
    cd ${PATH_TO_SOURCEMAPS}
fi

SENTRY_API_URL="${SENTRY_BASE_URL}/api/0"

SOMETHING_UPLOADED=false

function upload_file {
    curl ${SENTRY_API_URL}/projects/${SENTRY_ORGANIZATION}/${SENTRY_PROJECT}/releases/${SENTRY_RELEASE_VERSION}/files/ \
      -X POST \
      -H "Authorization: Bearer $SENTRY_TOKEN" \
      -F file=@$1 \
      -F name="~/$1"
    printf "\n"
}

# Create new release
printf "Creating release ${SENTRY_RELEASE_VERSION}\n"
curl ${SENTRY_API_URL}/projects/${SENTRY_ORGANIZATION}/${SENTRY_PROJECT}/releases/ \
  -X POST \
  -H "Authorization: Bearer $SENTRY_TOKEN" \
  -H 'Content-Type: application/json' \
  -d "{\"version\": \"${SENTRY_RELEASE_VERSION}\"}"
printf "\n"

printf "Uploading source files and map files ...\n"

# Upload source files
for i in *.js; do
    if [ -f "$i" ]; then
        upload_file $i
        SOMETHING_UPLOADED=true
    else
        printf "No *.js files found at $(pwd) \n"
        break
    fi
done

# Upload source maps
for i in *.map; do
    if [ -f "$i" ]; then
        upload_file $i
        SOMETHING_UPLOADED=true
    else
        printf "No *.map files found at $(pwd) \n"
        break
    fi
done

if [ "$SOMETHING_UPLOADED" = true ]; then
    printf "Done uploading.\n"
fi

printf "Creating a deploy\n"
curl ${SENTRY_API_URL}/organizations/${SENTRY_ORGANIZATION}/releases/${SENTRY_RELEASE_VERSION}/deploys/ \
  -X POST \
  -H "Authorization: Bearer $SENTRY_TOKEN" \
  -H 'Content-Type: application/json' \
  -d "{\"environment\": \"production\", \"name\": \"${SENTRY_RELEASE_VERSION}\"}"
printf "\n"

printf "Done.\n"
