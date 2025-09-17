#!/bin/bash
set -euo pipefail  # Detener en caso de errores

# Variables obligatorias
REQUIRED_VARS=("FABRIC_INSTALLER_URL" "FABRIC_VERSION" "MC_VERSION" "JAVA_XMS" "JAVA_XMX" "JVM_FLAGS")

MISSING_VARS=()
for VAR in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!VAR:-}" ]; then
        MISSING_VARS+=("$VAR")
    fi
done

if [ ${#MISSING_VARS[@]} -ne 0 ]; then
    echo "###########################################################"
    echo "ERROR: Las siguientes variables obligatorias no están definidas:"
    for VAR in "${MISSING_VARS[@]}"; do
        echo "  - $VAR"
    done
    echo "Por favor define estas variables en tu docker-compose.yml antes de iniciar el servidor."
    echo "###########################################################"
    exit 1
fi

# Crear carpeta server
mkdir -p /minecraft/server
cd /minecraft/server

# Aceptar EULA automáticamente
echo "eula=true" > eula.txt

# Descargar Fabric Installer si no existe
if [ ! -f fabric-installer.jar ] || [ ! -s fabric-installer.jar ]; then
    echo "Descargando Fabric Installer..."
    curl -fSL -o fabric-installer.jar "$FABRIC_INSTALLER_URL"
fi

# Instalar Fabric Server si no está presente
if [ ! -f fabric-server-launch.jar ]; then
    echo "Instalando Fabric Server..."
    java -jar fabric-installer.jar server -mcversion "$MC_VERSION" -loader "$FABRIC_VERSION" -downloadMinecraft
fi

# Ejecutar servidor como PID 1
echo "Iniciando servidor Minecraft..."
exec java -Xms${JAVA_XMS} -Xmx${JAVA_XMX} ${JVM_FLAGS} -jar fabric-server-launch.jar nogui
