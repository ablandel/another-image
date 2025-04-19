FROM eclipse-temurin:21-jdk-alpine-3.21 AS build
WORKDIR /app
COPY . .
RUN ./mvnw clean package -Dmaven.test.skip=true
RUN java -Djarmode=layertools -jar target/*-uber.jar extract
RUN jar xf target/*-uber.jar \
  && jdeps --multi-release 21 --recursive --ignore-missing-deps --print-module-deps --class-path 'BOOT-INF/lib/*' BOOT-INF/classes/ > deps.info \
  && rm target/*-uber.jar
RUN jlink --add-modules $(cat deps.info) --compress 2 --no-header-files --no-man-pages --output custom-jre

FROM alpine:3.21
COPY --from=build /app/custom-jre /app/custom-jre
COPY --from=build /app/dependencies /app/dependencies
COPY --from=build /app/spring-boot-loader /app/spring-boot-loader
COPY --from=build /app/application /app/application
ENTRYPOINT ["/app/custom-jre/bin/java", "-cp", "/app/spring-boot-loader:/app/dependencies/BOOT-INF/lib/*:/app/application/BOOT-INF/classes", "-Dloader.main=github.ablandel.anotherimage.AnotherImageApplicationKt", "org.springframework.boot.loader.launch.PropertiesLauncher"]
