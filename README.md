# Projeto Prático: Servidor Web e Banco de Dados Linux

Repositório de automação e código-fonte para implantação de um servidor de rede completo em **Ubuntu Server 24.04 LTS**, desenvolvido para a disciplina de Redes/Administração de Servidores no **IFSP – Câmpus São João da Boa Vista**.

---

## Arquitetura e Requisitos Atendidos

| Componente | Tecnologia | Porta / Endereço | Função |
| :--- | :--- | :--- | :--- |
| **Sistema Operacional** | Ubuntu Server 24.04 LTS | `22` (SSH) | Base do servidor em rede (Modo Bridge) |
| **SGBD** | MariaDB Server | `3306` (Localhost) | Persistência de dados das aplicações PHP e Java |
| **Servidor HTTP + PHP** | Apache2 + PHP 8.3 | `80` (HTTP) | Hospedagem de aplicações PHP |
| **Aplicação Open Source** | WordPress (CMS) | `http://<IP>/wordpress` | Sistema de gerenciamento de conteúdo conectado ao MariaDB |
| **Servidor Java Web** | Apache Tomcat 10 + OpenJDK 17 | `8080` (HTTP) | Container Servlet/JSP com consulta JDBC ao MariaDB |

---

## Estrutura do Repositório

```text
servidor-linux-redes/
├── README.md                 # Este guia de configuração e fluxo de trabalho
├── scripts/
│   ├── 01-rede-firewall.sh   # Configuração de rede, SSH e regras do UFW
│   ├── 02-setup-mariadb.sh   # Instalação e hardening do MariaDB
│   ├── 03-setup-apache.sh    # Instalação do Apache2, PHP e WordPress
│   └── 04-setup-tomcat.sh    # Instalação do OpenJDK 17, Tomcat 10 e deploy .war
├── database/
│   └── init.sql              # Criação de bancos, usuários, permissões e tabela de teste
├── app-java/                 # Código-fonte da aplicação Java Web (JSP/Servlet + JDBC)
└── configs/                  # Arquivos de configuração auxiliares (VirtualHosts, etc.)
```

## Guia para os Integrantes: Como Configurar o Ambiente
1. Clonar o Repositório
Abra o terminal (Ubuntu/WSL ou Linux) e clone o projeto:

```text
# Via SSH (recomendado se já configurou sua chave no GitHub)
git clone git@github.com:LariBits/servidor-linux-redes.git

# Ou via HTTPS
git clone [https://github.com/LariBits/servidor-linux-redes.git](https://github.com/LariBits/servidor-linux-redes.git)\

cd servidor-linux-redes
```

2. Configurar sua Identidade no Git (se for a primeira vez na máquina)
Bash

```text
git config --global user.name "Seu Nome"
git config --global user.email "seu-email-do-github@exemplo.com"
```

3. Fluxo de Trabalho (Branches e Commits)
Nunca faça alterações diretamente na branch main. Siga sempre esta ordem antes de programar:

```text
# 1. Atualize sua branch main local
git checkout main
git pull origin main

# 2. Crie uma branch para a sua tarefa
git checkout -b feat/sua-tarefa

# 3. Após editar seus arquivos, salve e envie para o GitHub
git add .
git commit -m "feat: descrição clara do que foi feito"
git push -u origin feat/sua-tarefa
```

# Como Executar o Provisionamento no Servidor
Na Máquina Virtual limpa configurada com placa de rede em Modo Bridge:

Instale o Git e clone o projeto:
```text
sudo apt update && sudo apt install git -y
git clone [https://github.com/LariBits/servidor-linux-redes.git](https://github.com/LariBits/servidor-linux-redes.git)
cd servidor-linux-redes
```
Garanta permissão de execução e rode os scripts na ordem:
```text
chmod +x scripts/*.sh
sudo bash scripts/01-rede-firewall.sh
sudo bash scripts/02-setup-mariadb.sh
sudo mysql < database/init.sql
sudo bash scripts/03-setup-apache.sh
sudo bash scripts/04-setup-tomcat.sh

```
## Checklist de Validação em Rede:

* Descobrir IP da VM: ip a
* Testar WordPress a partir de outro PC da sala: http://<IP_DO_SERVIDOR>/wordpress
* Testar Aplicação Java a partir de outro PC da sala: http://<IP_DO_SERVIDOR>:8080/app_java
* Testar persistência após reinicialização (sudo reboot): sudo systemctl status apache2 mariadb tomcat10
EOF
