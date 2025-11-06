#!/bin/sh
set -e

echo "[entrypoint] Devpi starting with data dir: $DEVPI_SERVERDIR"

# Проверяем, смонтирован ли volume
if [ ! -w "$DEVPI_SERVERDIR" ]; then
  echo "[entrypoint] ERROR: $DEVPI_SERVERDIR не смонтирован или недоступен для записи!"
  ls -ld "$DEVPI_SERVERDIR"
  exit 1
fi

# Инициализация только при пустом каталоге
if [ ! -f "$DEVPI_SERVERDIR/.serverversion" ]; then
  echo "[entrypoint] Initializing devpi-server data directory..."
  devpi-init --serverdir "$DEVPI_SERVERDIR"

  echo "[entrypoint] Starting temporary server for setup..."
  devpi-server --serverdir "$DEVPI_SERVERDIR" --host 127.0.0.1 --port 3141 &
  SERVER_PID=$!

  # Ждём пока сервер поднимется
  for i in $(seq 1 30); do
    if curl -sf http://127.0.0.1:3141 >/dev/null 2>&1; then
      echo "[entrypoint] Devpi is ready"
      break
    fi
    echo "[entrypoint] Waiting for devpi-server to start ($i/30)..."
    sleep 1
  done

  echo "[entrypoint] Configuring root user..."
  devpi use http://127.0.0.1:3141
  devpi login root --password=""
  devpi user -m root password="$DEVPI_PASSWORD"

  echo "[entrypoint] Creating local index..."
  devpi login root --password="$DEVPI_PASSWORD"
  devpi index -c root/devpi-local type=stage bases=root/pypi || true

  echo "[entrypoint] Shutting down temporary server..."
  kill $SERVER_PID
  wait $SERVER_PID || true
fi

echo "[entrypoint] Launching main devpi-server..."
exec devpi-server --serverdir "$DEVPI_SERVERDIR" --host 0.0.0.0 --port "$DEVPI_PORT"