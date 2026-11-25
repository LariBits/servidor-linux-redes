# Projeto Prático: Servidor Web e Banco de Dados Linux

Repositório de automação e código-fonte para implantação de um servidor de rede completo em **Ubuntu Server 24.04 LTS**, desenvolvido para a disciplina de Redes/Administração de Servidores no **IFSP – Câmpus São João da Boa Vista**.

**Integrantes:** <Larissa Silva>; <Leticia Teles>; <João Gregorio>; <Rebeca Laia>
**Disciplina / Professor:** Redes de Computadores – <Prof. Roan>

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
└── configs/                  # Arquivos de configuração auxiliares
    └── 01-ip-fixo.yaml.exemplo  # Modelo Netplan para fixar o IP do servidor
```

## Guia para os Usuários: Como Configurar o Ambiente
1. Clonar o Repositório
Abra o terminal (Ubuntu/WSL ou Linux) e clone o projeto:

```bash
# Via SSH (recomendado se já configurou sua chave no GitHub)
git clone git@github.com:LariBits/servidor-linux-redes.git

# Ou via HTTPS
git clone https://github.com/LariBits/servidor-linux-redes.git

cd servidor-linux-redes
```

2. Configurar sua Identidade no Git (se for a primeira vez na máquina)

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu-email-do-github@exemplo.com"
```

3. Fluxo de Trabalho (Branches e Commits)
Nunca faça alterações diretamente na branch main. Siga sempre esta ordem antes de programar:

```bash
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
```bash
sudo apt update && sudo apt install git -y
git clone https://github.com/LariBits/servidor-linux-redes.git
cd servidor-linux-redes
```

**(Recomendado) Fixar o IP do servidor**

Para que o endereço não mude entre reinicializações, configure um IP fixo usando o modelo [configs/01-ip-fixo.yaml.exemplo](configs/01-ip-fixo.yaml.exemplo). As instruções estão nos comentários do próprio arquivo (combine o IP com o professor/TI antes, para evitar conflito).

Garanta permissão de execução e rode os scripts na ordem:
```bash
chmod +x scripts/*.sh
sudo bash scripts/01-rede-firewall.sh
sudo bash scripts/02-setup-mariadb.sh   # já executa o database/init.sql
sudo bash scripts/03-setup-apache.sh
sudo bash scripts/04-setup-tomcat.sh
```

**Concluir a instalação do WordPress**

Abra no navegador `http://<IP>/wordpress/wp-admin/install.php` e preencha o título do site, usuário administrador e senha.

## Checklist de Validação em Rede

> Todos os testes de acesso devem ser feitos a partir de **OUTRO PC da sala**, não da própria VM — é isso que comprova que o servidor está acessível na rede.

- [ ] Descobrir o IP da VM: `ip a`
- [ ] Testar SSH a partir de outro PC da sala: `ssh <usuario>@<IP_DO_SERVIDOR>`
- [ ] Testar WordPress a partir de outro PC da sala: `http://<IP_DO_SERVIDOR>/wordpress`
- [ ] Testar Aplicação Java a partir de outro PC da sala: `http://<IP_DO_SERVIDOR>:8080/app_java`
- [ ] Testar persistência após reinicialização (`sudo reboot`): `sudo systemctl status apache2 mariadb tomcat10`

## Solução de Problemas

| Sintoma | O que verificar |
| :--- | :--- |
| Não abre de outro PC | `sudo ufw status` (portas 22, 80 e 8080 liberadas) e se a placa de rede da VM está em **Modo Bridge** |
| WordPress mostra "Erro ao estabelecer conexão com o banco de dados" | `sudo systemctl status mariadb` e os valores de `DB_NAME`, `DB_USER` e `DB_PASSWORD` em `/var/www/html/wordpress/wp-config.php` |
| `/app_java` retorna 404 | `ls /var/lib/tomcat10/webapps` (o `app_java` precisa estar lá) e `sudo journalctl -u tomcat10` |
| Página Java mostra erro de banco | `sudo mysql -e "SELECT * FROM app_java.relatorios_sistema;"` para confirmar que a tabela existe e tem dados |
