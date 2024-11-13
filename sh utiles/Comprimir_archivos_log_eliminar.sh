#!/bin/bash

# Directorio base de los logs
LOGS_BASE_DIR="/apps/subasta-aduanera-laravel/storage/logs"

# Obtener la fecha actual para el nombre del archivo comprimido
DATE=$(date +'%Y-%m-%d')

# Directorios de logs específicos
LOG_DIRS=("." "bids" "clave_unica" "linkify" "strapi" "winners")

# Recorre cada directorio de logs
for DIR in "${LOG_DIRS[@]}"; do
  LOG_DIR_PATH="$LOGS_BASE_DIR/$DIR"

  # Verificar si el directorio existe
  if [ -d "$LOG_DIR_PATH" ]; then
    # Buscar archivos .log en el directorio actual
    LOG_FILES=$(find "$LOG_DIR_PATH" -maxdepth 1 -type f -name "*.log")

    # Comprobar si hay archivos .log para comprimir
    if [ -n "$LOG_FILES" ]; then
      # Crear el archivo .tar.gz con los logs encontrados
      tar -czf "$LOG_DIR_PATH/logs_$DATE.tar.gz" -C "$LOG_DIR_PATH" $(basename -a $LOG_FILES)

      # Verificar que la compresión fue exitosa antes de eliminar los archivos originales
      if [ $? -eq 0 ]; then
        echo "Compresión exitosa en $LOG_DIR_PATH/logs_$DATE.tar.gz, eliminando archivos .log..."
        # Eliminar los archivos .log después de comprimirlos
        rm $LOG_FILES
        echo "Archivos .log eliminados en $LOG_DIR_PATH."
      else
        echo "Error al comprimir los logs en $LOG_DIR_PATH. No se eliminarán los archivos .log."
      fi
    else
      echo "No hay archivos .log en $LOG_DIR_PATH para comprimir."
    fi
  else
    echo "El directorio $LOG_DIR_PATH no existe."
  fi
done
