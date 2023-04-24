FROM openjdk:8-jdk-alpine
EXPOSE 8083
ADD target/ExamThourayaS2-1.0.jar ExamThourayaS2-1.0.jar
ENTRYPOINT ["java","-jar","/ExamThourayaS2-1.0.jar"]