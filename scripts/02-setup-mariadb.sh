#!/bin/bash
set -e

echo "==================================================="
echo " [ETAPA 2] Instalando e Configurando MariaDB       "
echo "==================================================="

sudo apt update
sudo apt install -y mariadb-server mariadb-client

sudo systemctl enable mariadb
sudo systemctl start mariadb

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SQL_FILE="$SCRIPT_DIR/../database/init.sql"

if [ -f "$SQL_FILE" ]; then
    echo "-> Executando script SQL inicial ($SQL_FILE)..."
    sudo mysql < "$SQL_FILE"
    echo "-> Bancos 'app_cms' e 'app_java' configurados com sucesso!"
else
    echo "ERRO: Arquivo $SQL_FILE não encontrado!"
    exit 1
fi

echo "==================================================="
echo " [CONCLUÍDO] MariaDB ativo e bancos criados!       "
echo "==================================================="
sudo systemctl status mariadb --no-pager | head -n 5
