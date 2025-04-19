# Another Image (ﾉ◕ヮ◕)ﾉ*:･ﾟ✧🐳

Simple project to test Maven + GraalVM native images + Spring Boot Docker image generation (uber - plain - native).

The dummy Spring Boot application only include the `spring-boot-starter-actuator` actuator endpoint
at [http://localhost:8080/actuator](http://localhost:8080/actuator).

The three images can be created via the usage of the `build.sh` script or with the commands in the second part of this
README.

Small summaries are available after the `build.sh` script execution to compare the image sizes and the build times
(each build time is inaccurate due to Docker images and layers cache shared between the three image build generations -
this project does not aim to be a benchmark (¬‿¬)).

For those who do not want to run the build on their machines and see the result by themselves, here are some results I
obtained on one of my (very) old but faithful machines:

| Image type | Build time | Image size | Initialization time |
|------------|------------|------------|---------------------|
| uber       | 123.47s    | 385MB      | ~3.51s              |
| plain      | 116.02s    | 101MB      | ~3.07s              |
| native     | 305.93s    | 121MB      | ~0.12s              |

Build times have been calculated on an arbitrary average of 5 builds (with the base image on the machine).
Initialization times have been calculated on an arbitrary average of 20 launches.

## Build all the images one after the other

Do not hesitate to do something else during the build, it may take a while depending on your machine.

```shell
./build.sh
```

## Build image and run the container with the uber jar

Build the image:

```shell
docker build -t another-image:uber -f uber.Dockerfile .
```

Run the container:

```shell
docker run --rm -p 8080:8080 another-image:uber 
```

## Build image and run the container with the plain jar

Build the image:

```shell
docker build -t another-image:plain -f plain.Dockerfile .
```

Run the container:

```shell
docker run --rm -p 8080:8080 another-image:plain 
```

## Build image and run the container with the native executable

Build the image:

```shell
./mvnw -Pnative -Dspring-boot.build-image.imageName=another-image:native spring-boot:build-image
```

Run the container:

```shell
docker run --rm -p 8080:8080 another-image:native
```