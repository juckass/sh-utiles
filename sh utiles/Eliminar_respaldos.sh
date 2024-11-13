#!/bin/bash

# Obtener el año y mes actual
YEAR=$(date +'%Y')
MONTH=$(date +'%m')

# Directorio de los backups actuales
BACKUP_DIR="/apps/db_backups/$YEAR/$MONTH"

# Verificar que el directorio exista
if [ -d "$BACKUP_DIR" ]; then
  # Listar los archivos de respaldo en orden de fecha de modificación
  BACKUP_FILES=$(ls -t "$BACKUP_DIR"/mongo_backup_*.tar.gz 2>/dev/null)

  # Contar el total de archivos de respaldo
  TOTAL_FILES=$(echo "$BACKUP_FILES" | wc -l)

  # Calcular cuántos archivos borrar (todos menos los últimos 4)
  FILES_TO_DELETE=$((TOTAL_FILES - 4))

  if [ "$FILES_TO_DELETE" -gt 0 ]; then
    # Borrar los archivos más antiguos, manteniendo solo los últimos 4
    echo "$BACKUP_FILES" | tail -n "$FILES_TO_DELETE" | xargs -d '\n' rm --
  else
    echo "No hay archivos suficientes para eliminar. Se conservan los últimos 4 respaldos."
  fi
else
  echo "El directorio $BACKUP_DIR no existe."
fi
