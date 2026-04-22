# Stage 1: Download the jar
FROM eclipse-temurin:25-jre AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /download
ARG VERSION=1.21.1
RUN curl -o server.jar "https://api.purpurmc.org/v2/purpur/${VERSION}/latest/download"

# Stage 2: Final image (no curl!)
FROM eclipse-temurin:25-jre

WORKDIR /opt/
COPY setup.sh /opt/
COPY --from=builder /download/server.jar /opt/purpur/server.jar
RUN chmod +x /setup.sh && mkdir -p /opt/purpur

ENV VERSION=1.21.1
ENV MEMORY=4G
ENV INCUBATOR=true

ENTRYPOINT ["./setup.sh"]
