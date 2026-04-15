# 1단계: 빌드 단계
FROM gradle:8.5-jdk21 AS build
USER root
WORKDIR /home/gradle/src
# 전체 파일 복사
COPY . .

# 윈도우 줄바꿈 문자 제거 및 실행 권한 부여 (에러 방지 핵심 코드)
RUN sed -i 's/\r$//' gradlew
RUN chmod +x gradlew

# 빌드 실행 (WAR 생성)
RUN ./gradlew bootWar -x test

# 2단계: 실행 단계
FROM eclipse-temurin:21-jdk-jammy
WORKDIR /app
# 빌드된 파일 중 실행 가능한 war만 복사
COPY --from=build /home/gradle/src/build/libs/*[!plain].war app.war

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]