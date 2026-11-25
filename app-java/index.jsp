<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Monitoramento do Servidor Linux - Java Web</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f6f9; color: #333; }
        .container { max-width: 900px; margin: auto; background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        h1 { color: #1e3a8a; border-bottom: 2px solid #e2e8f0; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border: 1px solid #cbd5e1; text-align: left; }
        th { background-color: #1e3a8a; color: white; }
        tr:nth-child(even) { background-color: #f8fafc; }
        .badge { background-color: #dcfce7; color: #166534; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 0.85em; }
        .erro { background-color: #fee2e2; color: #991b1b; padding: 15px; border-radius: 6px; }
    </style>
</head>
<body>
<div class="container">
    <h1>Status dos Serviços - Servidor Linux (Java Web + JDBC)</h1>
    <p>Consulta executada em tempo real no banco de dados <strong>MariaDB (app_java)</strong> via <strong>Apache Tomcat 10</strong>.</p>

    <%
        String url = "jdbc:mariadb://localhost:3306/app_java";
        String user = "usr_java";
        String pass = "SenhaJavaSegura123!";

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT id, modulo, status_servico, observacao, data_verificacao FROM relatorios_sistema ORDER BY id");
    %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Módulo / Serviço</th>
                        <th>Status</th>
                        <th>Observação</th>
                        <th>Data Verificação</th>
                    </tr>
                </thead>
                <tbody>
                <% while (rs.next()) { %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><strong><%= rs.getString("modulo") %></strong></td>
                        <td><span class="badge"><%= rs.getString("status_servico") %></span></td>
                        <td><%= rs.getString("observacao") %></td>
                        <td><%= rs.getTimestamp("data_verificacao") %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
    <%
        } catch (Exception e) {
    %>
            <div class="erro">
                <strong>Erro ao consultar banco de dados:</strong> <%= e.getMessage() %>
            </div>
    <%
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>
</div>
</body>
</html>
