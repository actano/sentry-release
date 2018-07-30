# sentry-release

This script is meant to be run on a CI server. It only needs `curl` as external dependency.

## Environment

The following variables need to be set exported in the environment or passed to the script. We recommend [Vault](https://www.vaultproject.io/) by HashiCorp to manage your secrets.

* `SENTRY_BASE_URL`, usually `https://sentry.yourdomain.com`
* `SENTRY_TOKEN`, needs `project:write` scope
* `SENTRY_ORGANIZATION`
* `SENTRY_PROJECT`
* `SENTRY_RELEASE_VERSION`

## Optional parameters

* `PATH_TO_SOURCEMAPS` defaults to `./`
