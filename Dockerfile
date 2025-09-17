# Imagen base: Ubuntu LTS más reciente
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias necesarias en un solo RUN para reducir capas
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-21-jre-headless \
        curl \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# Instalar mcrcon desde binario precompilado
RUN curl -fSL -o /tmp/mcrcon.tar.gz "https://github.com/neburbot/fabric-docker-server/releases/download/mcrcon/mcrcon-0.7.2-linux-x86-64.tar.gz" \
    && tar -xzf /tmp/mcrcon.tar.gz -C /usr/local/bin mcrcon \
    && rm /tmp/mcrcon.tar.gz

# Variables de entorno de Java
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Carpeta de trabajo
WORKDIR /minecraft

# Copiar scripts al contenedor
COPY start.sh /start.sh

# Dar permisos de ejecución al script principal
RUN chmod +x /start.sh

# Minecraft
EXPOSE 25565
# RCON (solo interno)
EXPOSE 25575

# Ejecutar script como PID 1
CMD ["/start.sh"]
