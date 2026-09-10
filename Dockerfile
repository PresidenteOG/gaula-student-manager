# ── Build stage ───────────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY Backend/pom.xml .
RUN mvn -B -q dependency:go-offline
COPY Backend/src ./src
RUN mvn -B -q clean package -DskipTests

# ── Run stage ─────────────────────────────────────────────────
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/gaula-backend-*.jar app.jar
EXPOSE 8080
ENV SPRING_PROFILES_ACTIVE=demo
ENTRYPOINT ["java", "-jar", "app.jar"]
