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

# 빌드된 파일 목록을 확인하고, 어떤 이름의 war든 app.war로 복사합니다.
# 빌드된 결과물이 libs 폴더 안에 있는지 확인하고 app.war로 이름을 고정합니다.
COPY --from=build /home/gradle/src/build/libs/*.war /app/app.war

# 실행 권한 부여
RUN chmod +x /app/app.war

# 임시 폴더 생성
RUN mkdir -p /tmp/uploads/profile /tmp/uploads/board

EXPOSE 8080

# 절대 경로를 사용하여 실행
ENTRYPOINT ["java", "-jar", "/app/app.war"]