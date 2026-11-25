#!/bin/bash

set -e

echo "==================================================="
echo " [ETAPA 1] Configurando Infraestrutura, SSH e Rede "
echo "==================================================="

echo "-> Atualizando lista de pacotes e ferramentas de rede..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y openssh-server ufw net-tools curl wget

echo "-> Habilitando e iniciando o servidor SSH..."
sudo systemctl enable ssh
sudo systemctl start ssh

echo "-> Configurando regras do Firewall (UFW)..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 22/tcp comment 'Acesso SSH'
sudo ufw allow 80/tcp comment 'Servidor Web Apache / PHP'
sudo ufw allow 8080/tcp comment 'Servidor Java Apache Tomcat'

sudo ufw --force enable

echo "==================================================="
echo " [CONCLUÍDO] Resumo da Rede e Firewall"
echo "==================================================="
echo "-> Status do Firewall:"
sudo ufw status verbose

echo ""
echo "-> Endereço(s) IP deste servidor na rede:"
hostname -I
echo "==================================================="
