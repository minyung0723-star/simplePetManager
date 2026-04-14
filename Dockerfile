# 1단계: Build stage
FROM gradle:8.5-jdk21 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
# gradlew에 실행 권한 부여 및 war 빌드
RUN chmod +x ./gradlew
RUN ./gradlew bootWar -x test

# 2단계: Run stage
FROM eclipse-temurin:21-jdk-jammy
EXPOSE 8080
# 빌드된 war 파일을 복사 (파일명은 프로젝트 이름에 따라 다를 수 있음)
COPY --from=build /home/gradle/src/build/libs/*.war app.war
ENTRYPOINT ["java", "-jar", "/app.war"]