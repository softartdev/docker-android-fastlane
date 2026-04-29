# docker-android-fastlane
[![Docker Pulls](https://img.shields.io/docker/pulls/softartdev/android-fastlane)](https://hub.docker.com/repository/docker/softartdev/android-fastlane)
[![Build and publish to DockerHub](https://github.com/softartdev/docker-android-fastlane/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/softartdev/docker-android-fastlane/actions/workflows/docker-publish.yml)

You can use this image on such CI/CD like Bitbucket/GitLab/GitHub Actions/etc, which uses docker containers.

Example for bitbucket-pipelines.yml file:
```
image: softartdev/android-fastlane

pipelines:
  default:
    - step:
        name: Build step
        script:
          - ./gradlew build
    - step:
        name: Publish step
        script:
         - fastlane playstore
```
For fastlane step within your repository you must have Fastfile with match lane inside:
```
default_platform(:android)

platform :android do
  lane :playstore do
    gradle(
      task: 'bundle', # for AAB, or use 'assemble' for APK
      build_type: 'Release'
    )
    upload_to_play_store # Uploads the APK/AAB built in the gradle step above
  end
end
```
Desirable debug it locally before push to remote repository.

## Docker cheat sheet

Pull the published image:
```sh
docker pull softartdev/android-fastlane:37
```
Create and enter a named container with the current project mounted:
```sh
docker run --name android-fastlane -it \
  -v "$PWD":/workspace \
  -w /workspace \
  softartdev/android-fastlane:37 \
  bash
```
Start the same container again:
```sh
docker start -ai android-fastlane
```
Open another terminal inside the running container:
```sh
docker exec -it android-fastlane bash
```
Remove the named container:
```sh
docker stop android-fastlane
docker rm android-fastlane
```
Run a project from the current directory inside a disposable container:
```sh
docker run --rm -it \
  -v "$PWD":/workspace \
  -w /workspace \
  softartdev/android-fastlane:37 \
  bash
```
Build the mounted project:
```sh
docker run --rm -it \
  -v "$PWD":/workspace \
  -w /workspace \
  softartdev/android-fastlane:37 \
  ./gradlew build
```
Publish the mounted project:
```sh
docker run --rm -it \
  -v "$PWD":/workspace \
  -w /workspace \
  softartdev/android-fastlane:37 \
  fastlane playstore
```
[Setup Fastlane](https://docs.fastlane.tools/getting-started/android/setup/)

[Debug your pipelines locally with Docker](https://confluence.atlassian.com/bitbucket/debug-your-pipelines-locally-with-docker-838273569.html)
