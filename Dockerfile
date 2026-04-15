# 1단계: 빌드 단계
FROM gradle:8.5-jdk21 AS build
USER root
WORKDIR /home/gradle/src
COPY . .

# 윈도우 줄바꿈 문자 제거 및 실행 권한 부여 (필수)
RUN sed -i 's/\r$//' gradlew
RUN chmod +x gradlew

# 빌드 실행 (WAR 생성)
RUN ./gradlew clean bootWar -x test

# 2단계: 실행 단계
FROM eclipse-temurin:21-jdk-jammy
WORKDIR /app

# 빌드된 war 파일 복사 (plain 파일 제외)
COPY --from=build /home/gradle/src/build/libs/*[!plain].war app.war

# 리눅스 환경에 맞는 업로드 폴더 생성
RUN mkdir -p /tmp/uploads/profile /tmp/uploads/board

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]