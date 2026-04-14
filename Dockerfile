# 1단계: 빌드 단계
FROM gradle:8.5-jdk21 AS build
# 윈도우 환경의 권한 문제를 방지하기 위해 root로 잠시 전환
USER root 
COPY . /home/gradle/src
WORKDIR /home/gradle/src

# 윈도우 줄바꿈 문자(\r)를 리눅스 형식으로 변환 (빌드 실패 방지 핵심)
RUN sed -i 's/\r$//' gradlew
RUN chmod +x ./gradlew

# 빌드 실행 (test는 제외)
RUN ./gradlew bootWar -x test

# 2단계: 실행 단계
FROM eclipse-temurin:21-jdk-jammy
WORKDIR /app

# 빌드된 war 파일 중 plain이 붙지 않은 실행 가능한 war만 복사
COPY --from=build /home/gradle/src/build/libs/*[!plain].war app.war

# JSP 및 업로드 경로를 위한 임시 디렉토리 생성 (필요 시)
RUN mkdir -p /tmp/uploads/profile /tmp/uploads/board

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]