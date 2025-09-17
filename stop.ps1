# Wrapper de apagado seguro de Minecraft
# ----------------------------------------------------------
# NOTA: Ejecutar siempre desde Windows PowerShell

$ContainerName = "server-container"
# Obtener la contraseña RCON desde la variable de entorno del contenedor
$RconPassword = docker exec $ContainerName printenv RCON_PASSWORD
$RconPort = 25575

Write-Host "Desactivando reinicio automatico temporalmente..."
docker update --restart=no $ContainerName

Write-Host "Enviando comando /stop a Minecraft..."
docker exec -i $ContainerName /usr/local/bin/mcrcon -H 127.0.0.1 -P $RconPort -p $RconPassword "stop"

Write-Host "Esperando a que el contenedor se apague completamente..."
docker wait $ContainerName | Out-Null

Write-Host "Contenedor apagado correctamente."
