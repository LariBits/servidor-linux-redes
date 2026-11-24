# Projeto Prático: Servidor Web e Banco de Dados Linux

Repositório de automação e código-fonte para implantação de um servidor de rede completo em **Ubuntu Server 24.04 LTS**, desenvolvido para a disciplina de Redes/Administração de Servidores no **IFSP – Câmpus São João da Boa Vista**.

---

## 📋 Arquitetura e Requisitos Atendidos

| Componente | Tecnologia | Porta / Endereço | Função |
| :--- | :--- | :--- | :--- |
| **Sistema Operacional** | Ubuntu Server 24.04 LTS | `22` (SSH) | Base do servidor em rede (Modo Bridge) |
| **SGBD** | MariaDB Server | `3306` (Localhost) | Persistência de dados das aplicações PHP e Java |
| **Servidor HTTP + PHP** | Apache2 + PHP 8.3 | `80` (HTTP) | Hospedagem de aplicações PHP |
| **Aplicação Open Source** | WordPress (CMS) | `http://<IP>/wordpress` | Sistema de gerenciamento de conteúdo conectado ao MariaDB |
| **Servidor Java Web** | Apache Tomcat 10 + OpenJDK 17 | `8080` (HTTP) | Container Servlet/JSP com consulta JDBC ao MariaDB |

---

## 📂 Estrutura do Repositório

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
