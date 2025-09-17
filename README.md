# 📝 Guía completa — Servidor Minecraft Fabric con Docker

Esta guía te ayudará a preparar, ejecutar y actualizar un servidor de Minecraft Fabric usando Docker, con configuraciones flexibles de RAM y RCON centralizado.

---

## 1️⃣ Preparar el proyecto

1. Crea la carpeta de trabajo:

```bash
mkdir minecraft-fabric && cd minecraft-fabric
```

2. Coloca dentro los siguientes archivos:

* `Dockerfile`
* `start.sh`
* `docker-compose.yml`
* `stop.ps1` (opcional, para apagar desde Windows)

> Opcional: crea subcarpetas `mods`, `backups` o `worlds` dentro de una carpeta llamada server según necesites.

---

## 2️⃣ Construir la imagen de Docker

Desde la carpeta del proyecto, ejecuta:

```bash
docker compose build
```

\*Se puede utilizar la flag `--no-cache` si quieres forzar la reconstrucción completa.

> Esto generará la imagen personalizada con **Ubuntu 24.04 + Java 21 + Fabric**.

---

## 3️⃣ Configurar variables de memoria y RCON

En `docker-compose.yml` puedes definir la memoria y flags de la JVM, así como la contraseña RCON:

```yaml
environment:
  MC_VERSION: "1.21.8"
  FABRIC_VERSION: "0.16.14"
  FABRIC_INSTALLER_URL: "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.1.0/fabric-installer-1.1.0.jar"
  JAVA_XMS: "8G"
  JAVA_XMX: "8G"
  JVM_FLAGS: "-XX:+UseZGC -XX:+ZGenerational -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -XX:+OptimizeStringConcat -XX:+UseCompressedOops"
  RCON_PASSWORD: "15121173"
```

---

## 4️⃣ Levantar el servidor

Inicia el servidor en segundo plano:

```bash
docker compose up -d server-service
```

> Esto crea el contenedor `server-container` usando la configuración de `docker-compose.yml`.

---

## 5️⃣ Ver logs del servidor

Para monitorear la consola de Minecraft en tiempo real:

```bash
docker compose logs -f server-service
```

> Presiona `Ctrl+C` para salir.

---

## 6️⃣ Detener el servidor de manera segura

### Desde Windows (PowerShell):

Ejecuta `stop.ps1`:

```powershell
.\stop.ps1
```

> Esto asegura que los mundos se guarden correctamente.

---

## 7️⃣ Ejecutar comandos dentro del servidor con mcrcon

Puedes enviar comandos a Minecraft directamente desde tu host usando `mcrcon` dentro del contenedor. Por seguridad, en esta guía no mostramos la contraseña ni el puerto. Sustituye las variables RCON_PASSWORD y RCON_PORT según tu configuración:

```bash
docker exec -it server-container mcrcon -H 127.0.0.1 -P <RCON_PORT> -p "<RCON_PASSWORD>" "/say Hola Mundo!"
```

> Sustituye `/say Hola Mundo!` por cualquier comando de Minecraft.

---

## 8️⃣ Limpiar contenedores e imágenes de Docker

Para eliminar contenedores detenidos y liberar espacio:

```bash
docker container prune -f
```

Para eliminar imágenes no utilizadas:

```bash
docker image prune -f
```

> Esto ayuda a mantener limpio el entorno de Docker.

---

## 9️⃣ Actualizar Minecraft o Fabric

### Cambiar versión de Minecraft

Edita `docker-compose.yml`:

```yaml
MC_VERSION: "1.21.9"
```

Reconstruye e inicia el servidor:

```bash
docker compose build
docker compose up -d server-service
```

### Cambiar versión de Fabric Loader

```yaml
FABRIC_VERSION: "0.16.15"
```

Reconstruye e inicia como antes.

### Cambiar URL del instalador de Fabric

```yaml
FABRIC_INSTALLER_URL: "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.1.0/fabric-installer-1.1.1.jar"
```

Reconstruye e inicia nuevamente.

---

## 🔟 Respaldo recomendado

Antes de cualquier actualización o cambio importante:

```bash
cp -r server server-backup-$(date +%F-%H%M%S)
```

> Esto protege tus mundos, mods y configuraciones.

---

## 📌 Buenas prácticas

1. Mantén siempre una copia de seguridad de `server`.
2. Evita exponer el puerto RCON a internet.
3. Actualiza Java y Fabric solo cuando tengas backup.
4. Ajusta `JAVA_XMS` y `JAVA_XMX` según la memoria del host.

---

✅ Con esta guía, tu servidor Fabric en Docker estará:

* Configurado de manera reproducible.
* Seguro mediante RCON centralizado.
* Flexible en memoria y actualizaciones.
