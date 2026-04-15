# 1단계: 빌드
FROM gradle:8.5-jdk21 AS build
USER root
WORKDIR /home/gradle/src
COPY . .

# 윈도우 줄바꿈 문자(\r)를 제거하고 실행 권한 부여
RUN sed -i 's/\r$//' gradlew
RUN chmod +x gradlew

# 빌드 실행 (WAR 생성)
RUN ./gradlew clean bootWar -x test

# 2단계: 실행
FROM eclipse-temurin:21-jdk-jammy
WORKDIR /app

# 빌드된 war 파일 복사
COPY --from=build /home/gradle/src/build/libs/*[!plain].war app.war

# 서버 업로드 폴더 생성 (config.yaml의 경로와 맞춰야 함)
RUN mkdir -p /tmp/uploads/profile /tmp/uploads/board

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]