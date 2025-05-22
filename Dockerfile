FROM jenkins/jenkins:lts

USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        docker.io \
        unzip \
        wget \
        curl \
        openjdk-17-jdk \
        python3-pip && \
        docker-compose-plugin && \
    usermod -aG docker jenkins

# Install Sonar Scanner
ENV SONAR_SCANNER_VERSION=5.0.1.3006

RUN cd /opt && \
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
    unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
    mv sonar-scanner-${SONAR_SCANNER_VERSION}-linux sonar-scanner && \
    ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip

ENV PATH="/opt/sonar-scanner/bin:${PATH}"

