# Brightspot GitHub Actions Workflows

A collection of [GitHub Actions](https://github.com/features/actions) Workflows to help build and deploy Brightspot projects.

## Brightspot Build
This workflow will provide a job that will build your project.

## AWS Cloud Deploy
This workflow is used to continuously deploy artifacts to an S3 bucket.

When GitHub Actions builds a push to your project (not a pull request), any files matching `build/*.{war,jar,zip}` will be uploaded to your S3 bucket with the prefix `builds/$DEPLOY_BUCKET_PREFIX/deploy/$BRANCH/$BUILD_NUMBER/`. Pull requests will upload the same files with a prefix of `builds/$DEPLOY_BUCKET_PREFIX/pull-request/$PULL_REQUEST_NUMBER/`.

For example, the 36th push to the `main` branch will result in the following files being created in your `exampleco-ops` bucket:

```text
builds/exampleco/deploy/master/36/exampleco-1.0-SNAPSHOT.war
builds/exampleco/deploy/master/36/exampleco-1.0-SNAPSHOT.zip
```

When the 15th pull request is created, the following files will be uploaded into your bucket:
```text
builds/exampleco/pull-request/15/exampleco-1.0-SNAPSHOT.war
builds/exampleco/pull-request/15/exampleco-1.0-SNAPSHOT.zip
```

## Usage

Variables used below:
`${_DEPLOY_BUCKET}`: S3 bucket to deploy to
`${_DEPLOY_BUCKET_PREFIX}`: Directory prefix within the S3 bucket
`${_PROJECT}`: Ops Desk short name for the project
`${_REGION}`: AWS region the project is deployed in

### Brightspot Cloud projects
```yaml
name: Build and Deploy

# this should match whatever the project wants to build
on:
  push:
    branches:
      - develop
      - release/*
    tags: v*

  pull_request:
    branches:
      - develop
      - release/*

# (optional) cancel an existing build if new changes have been pushed to same PR or branch
concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true

jobs:
  build-brightspot:
    uses: perfectsense/brightspot-github-actions-workflows/.github/workflows/brightspot-build.yml@v2
    secrets: inherit
    with:
      java-version: '8'  # needed only for Java 8 projects; default is '11'
      war-build-dir: site/build/libs  # needed only if project has site/ directory rather than web/
      runs-on: ubuntu-20.04-4core # needed only if using a different runner

  aws-cloud-deploy:
    needs: build-brightspot
    uses: perfectsense/brightspot-github-actions-workflows/.github/workflows/aws-cloud-deploy.yml@v2
    secrets: inherit
    with:
      project: ${_PROJECT}
      repository: ${_PROJECT}/${_PROJECT}
      region: ${_REGION}
      runs-on: ubuntu-20.04-4core # needed only if using a different runner
```

### Non-cloud projects
```yaml
name: Build and Deploy

# this should match whatever the project wants to build
on:
  push:
    branches:
      - develop
      - release/*
    tags: v*

  pull_request:
    branches:
      - develop
      - release/*

jobs:
  build-brightspot:
    uses: perfectsense/brightspot-github-actions-workflows/.github/workflows/brightspot-build.yml@v2
    secrets: inherit
    with:
      java-version: '8'  # needed only for Java 8 projects; default is '11'
      war-build-dir: site/build/libs  # needed only if project has site/ directory rather than web/
      runs-on: ubuntu-20.04-4core # needed only if using a different runner

  aws-cloud-deploy:
    needs: build-brightspot
    uses: perfectsense/brightspot-github-actions-workflows/.github/workflows/aws-cloud-deploy.yml@v2
    secrets: inherit
    with:
      region: ${_REGION}
      deploy-container: false
      deploy-s3: true
      deploy-bucket: ${_DEPLOY_BUCKET}
      deploy-bucket-prefix: ${_DEPLOY_BUCKET_PREFIX}  # as needed (check with Ops if unsure)
      runs-on: ubuntu-20.04-4core # needed only if using a different runner
```


### Projects migrating to Brightspot Cloud

Once the cloud migration is complete, the workflow should be updated to match the Brightspot Cloud configuration above.

```yaml
name: Build and Deploy

# this should match whatever the project wants to build
on:
  push:
    branches:
      - develop
      - release/*
    tags: v*

  pull_request:
    branches:
      - develop
      - release/*

jobs:
  build-brightspot:
    uses: perfectsense/brightspot-github-actions-workflows/.github/workflows/brightspot-build.yml@v2
    secrets: inherit
    with:
      java-version: '8'  # needed only for Java 8 projects; default is '11'
      war-build-dir: site/build/libs  # needed only if project has site/ directory rather than web/
      runs-on: ubuntu-20.04-4core # needed only if using a different runner

  aws-cloud-deploy:
    needs: build-brightspot
    uses: perfectsense/brightspot-github-actions-workflows/.github/workflows/aws-cloud-deploy.yml@v2
    secrets: inherit
    with:
      project: ${_PROJECT}
      repository: ${_PROJECT}/${_PROJECT}
      region: ${_REGION}
      deploy-container: true
      deploy-s3: true
      deploy-bucket: ${_DEPLOY_BUCKET}
      deploy-bucket-prefix: ${_DEPLOY_BUCKET_PREFIX}  # as needed (check with Ops if unsure)
      runs-on: ubuntu-20.04-4core # needed only if using a different runner
```
