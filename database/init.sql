-- Hardening básico (equivalente ao mysql_secure_installation)
DROP USER IF EXISTS ''@'localhost';
DROP USER IF EXISTS ''@'%';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db = 'test' OR Db = 'test\\_%';

CREATE DATABASE IF NOT EXISTS app_cms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'usr_cms'@'localhost' IDENTIFIED BY 'SenhaCmsSegura123!';
GRANT ALL PRIVILEGES ON app_cms.* TO 'usr_cms'@'localhost';

CREATE DATABASE IF NOT EXISTS app_java CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'usr_java'@'localhost' IDENTIFIED BY 'SenhaJavaSegura123!';
GRANT SELECT, INSERT, UPDATE, DELETE ON app_java.* TO 'usr_java'@'localhost';

FLUSH PRIVILEGES;

USE app_java;

CREATE TABLE IF NOT EXISTS relatorios_sistema (
    id INT AUTO_INCREMENT PRIMARY KEY,
    modulo VARCHAR(60) NOT NULL UNIQUE,
    status_servico VARCHAR(20) NOT NULL,
    observacao VARCHAR(120),
    data_verificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT IGNORE INTO relatorios_sistema (modulo, status_servico, observacao) VALUES
('Sistema Operacional Ubuntu Server', 'OPERACIONAL', 'Rede configurada em modo Bridge'),
('Servidor Web Apache2 + PHP 8.3', 'OPERACIONAL', 'Hospedando CMS WordPress na porta 80'),
('SGBD MariaDB Server', 'OPERACIONAL', 'Bancos app_cms e app_java ativos'),
('Container Java Apache Tomcat 10', 'OPERACIONAL', 'Aplicacao JSP conectada via JDBC na porta 8080');
