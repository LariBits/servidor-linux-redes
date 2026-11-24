#!/bin/bash
set -e

echo "==================================================="
echo " [ETAPA 4] Instalando Java, Tomcat 10 e App Web    "
echo "==================================================="

sudo apt update
sudo apt install -y openjdk-17-jdk tomcat10 wget

sudo systemctl enable tomcat10
sudo systemctl start tomcat10

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$SCRIPT_DIR/../app-java"
BUILD_DIR="/tmp/build-app-java"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/WEB-INF/lib"

cp "$APP_DIR/index.jsp" "$BUILD_DIR/"
cp "$APP_DIR/WEB-INF/web.xml" "$BUILD_DIR/WEB-INF/"

echo "-> Baixando MariaDB Connector/J (Driver JDBC)..."
wget -q -O "$BUILD_DIR/WEB-INF/lib/mariadb-java-client.jar" \
    https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/3.3.3/mariadb-java-client-3.3.3.jar

echo "-> Gerando arquivo app_java.war e realizando deploy..."
cd "$BUILD_DIR"
jar -cvf app_java.war *

sudo rm -rf /var/lib/tomcat10/webapps/app_java /var/lib/tomcat10/webapps/app_java.war
sudo cp app_java.war /var/lib/tomcat10/webapps/
sudo chown tomcat:tomcat /var/lib/tomcat10/webapps/app_java.war

sudo systemctl restart tomcat10

IP_SERVIDOR=$(hostname -I | awk '{print $1}')
echo "==================================================="
echo " [CONCLUÍDO] Aplicação Java Web implantada!        "
echo " Acesse no navegador: http://${IP_SERVIDOR}:8080/app_java"
echo "==================================================="
