#!/bin/bash

# Realiza un backup del sistema completo y luego solo del usuario y de la carpeta /root

# sudo apt update
# sudo apt install timeshift -y
# sudo timeshift --check
# sudo cp /etc/timeshift/timeshift.json /etc/timeshift/timeshift.json.bak
# sudo sed -i '/"exclude" : \[/,/\],/c\  "exclude" : ["/"],' /etc/timeshift/timeshift.json
# sudo timeshift --create --comments "initial system state"
# sudo cp /etc/timeshift/timeshift.json.bak /etc/timeshift/timeshift.json
# sudo timeshift --create --comments "initial user state"
# sudo timeshift --list

set -e  # Abortar si algún comando falla
set -o pipefail  # Detectar errores en tuberías

info() {
  echo -e "\e[34m[INFO]\e[0m $1"
}

error() {
  echo -e "\e[31m[ERROR]\e[0m $1" >&2
}

# Comprobar si timeshift está instalado
if command -v timeshift >/dev/null 2>&1; then
  info "Timeshift ya está instalado. Saltando instalación."
else
  info "Timeshift no está instalado. Actualizando repositorios e instalando..."
  if ! sudo apt update; then
    error "No se pudo actualizar la lista de paquetes. Abortando."
    exit 1
  fi

  if ! sudo apt install timeshift -y; then
    error "No se pudo instalar Timeshift. Abortando."
    exit 1
  fi
fi

# Verificar estado de timeshift
info "Verificando configuración de Timeshift..."
if ! sudo timeshift --check; then
  error "Timeshift detectó un error en la configuración. Abortando."
  exit 1
fi

# Crear copia de respaldo del archivo config
info "Guardando copia de seguridad del archivo de configuración..."
if ! sudo cp /etc/timeshift/timeshift.json /etc/timeshift/timeshift.json.bak; then
  error "No se pudo crear copia de seguridad del archivo de configuración. Abortando."
  exit 1
fi

# Modificar config para excluir todo
info "Modificando configuración para excluir todo el sistema..."
if ! sudo sed -i '/"exclude" : \[/,/\],/c\  "exclude" : ["/"],' /etc/timeshift/timeshift.json; then
  error "No se pudo modificar el archivo de configuración. Abortando."
  exit 1
fi

# Crear primer snapshot (sistema excluido)
info "Creando snapshot con exclusiones totales (vacío)..."
if ! sudo timeshift --create --comments "initial system state"; then
  error "No se pudo crear snapshot 'initial system state'. Abortando."
  exit 1
fi

# Restaurar config original
info "Restaurando configuración original del archivo..."
if ! sudo cp /etc/timeshift/timeshift.json.bak /etc/timeshift/timeshift.json; then
  error "No se pudo restaurar la configuración original. Abortando."
  exit 1
fi

# Crear segundo snapshot (config original)
info "Creando snapshot con configuración original..."
if ! sudo timeshift --create --comments "initial user state"; then
  error "No se pudo crear snapshot 'initial user state'. Abortando."
  exit 1
fi

# Listar snapshots creados
info "Listando snapshots actuales..."
if ! sudo timeshift --list; then
  error "No se pudo listar los snapshots."
  exit 1
fi

info "Proceso completado con éxito."