# docker-android-fastlane
You can use this image on such CI/CD like Bitbucket and GitLab, which uses docker containers.

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
        name: Test step
        script:
         - ./gradlew test
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
      task: 'clean bundle',
      build_type: 'Release'
    )
    upload_to_play_store # Uploads the APK built in the gradle step above
  end
end
```
Desirable debug it locally before push to remote repository.

[Setup Fastlane](https://docs.fastlane.tools/getting-started/android/setup/)

[Debug your pipelines locally with Docker](https://confluence.atlassian.com/bitbucket/debug-your-pipelines-locally-with-docker-838273569.html)
