# Brightspot Github Actions Workflows

A collection of [Git Hub Actions](https://github.com/features/actions) Workflows to help build and deploy Brightspot projects.

## Brightspot Build
This workflow will provide a job that will build your project.

## AWS Cloud Deploy
This workflow is used to continuously deploy artifacts to an S3 bucket.

When Git Hub Actions builds a push to your project (not a pull request), any files matching `build/*.{war,jar,zip}` will be uploaded to your S3 bucket with the prefix `builds/$DEPLOY_BUCKET_PREFIX/deploy/$BRANCH/$BUILD_NUMBER/`. Pull requests will upload the same files with a prefix of `builds/$DEPLOY_BUCKET_PREFIX/pull-request/$PULL_REQUEST_NUMBER/`.

For example, the 36th push to the `main` branch will result in the following files being created in your `exampleco-ops` bucket:

```
builds/exampleco/deploy/master/36/exampleco-1.0-SNAPSHOT.war
builds/exampleco/deploy/master/36/exampleco-1.0-SNAPSHOT.zip
```

When the 15th pull request is created, the following files will be uploaded into your bucket:
```
builds/exampleco/pull-request/15/exampleco-1.0-SNAPSHOT.war
builds/exampleco/pull-request/15/exampleco-1.0-SNAPSHOT.zip
```

## Usage
```
name: Build and Deploy

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
    uses: perfectsense/brightspot-github-actions-workflows/.github/workflows/brightspot-build.yml@v1

  aws-cloud-deploy:
    needs: build-brightspot
    uses: perfectsense/brightspot-github-actions-workflows/.github/workflows/aws-cloud-deploy.yml@v1
    secrets: inherit
    with:
      project: ${_PROJECT}
      repository: ${_PROJECT}/${_PROJECT}
      region: ${_REGION}
```
