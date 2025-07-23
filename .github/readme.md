# Modular github actions pipeline

# Usage

## Folder structure

The root folder normally is the frontend framework.  
Inside the root folder, there is the 'api' folder, which will contains the whole backend.

## Workflow

< Add workflow print here after its finished >

- explain steps

## Required environment variables

### Secrets:

- API_ENV_FILE

- CLOUD_USER
- CLOUD_ADDRESS
- CLOUD_RSA_KEY
- DOCKER_REPOSITORY_USERNAME
- DOCKER_REPOSITORY_PASSWORD
- DOCKER_API_REPOSITORY_USERNAME <optional>
- DOCKER_API_REPOSITORY_PASSWORD <optional>

- DB_ENV_FILE

- MANUAL_APPROVE_REQUESTOR_ID <optional | Required if using manual approval deploy>
- MANUAL_APPROVE_REQUESTOR_SECRET <optional | Required if using manual approval deploy>

### Variables:

- API_IMAGE_NAME
- API_SERVICE_NAME
- API_CONTAINER_NAME

- DB_SERVICE_NAME
- DB_CONTAINER_NAME

- PLATFORM_IMAGE_NAME
- PLATFORM_CONTAINER_NAME

- REGISTRY
- PROJECT_FOLDER

# TODO

- [ ] Enable frontend tests
- [ ] Integration tests
- [ ] Backend tests
- [ ] e2e

###### When using, reasonable fashion, credit the author(s). ;)
