# 1단계: Build stage
FROM gradle:8.5-jdk21 AS build
USER root
COPY . /home/gradle/src
WORKDIR /home/gradle/src

# 윈도우 줄바꿈 문자(\r) 제거 및 권한 부여 (에러 방지 핵심)
RUN sed -i 's/\r$//' gradlew
RUN chmod +x gradlew

# 빌드 실행
RUN ./gradlew bootWar -x test

# 2단계: Run stage
FROM eclipse-temurin:21-jdk-jammy
WORKDIR /app
# plain이 붙지 않은 실행용 war 파일만 복사
COPY --from=build /home/gradle/src/build/libs/*[!plain].war app.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]