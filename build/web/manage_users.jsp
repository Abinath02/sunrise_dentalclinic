<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.dao.UserDAO, com.sunrisedental.model.User, java.util.List" %>
<%@ page import="com.sunrisedental.dao.UserDAO, com.sunrisedental.model.User, java.util.List" %>
<%@ include file="header.jsp" %>

<style>
    .auth-card table { width: 100%; border-collapse: separate; border-spacing: 0; margin-top: 20px; border-radius: 12px; overflow: hidden; border: 1px solid #eef2f7; }
    .auth-card th { background: #f8fafc; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px; padding: 15px; border-bottom: 2px solid #edf2f7; text-align: left; }
    .auth-card td { padding: 15px; border-bottom: 1px solid #f1f5f9; color: #1e293b; font-size: 14px; }
    .auth-card tr:last-child td { border-bottom: none; }
    .auth-card tr:hover td { background-color: #f8fafc; }
    .badge { padding: 6px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
    .badge-doctor { background: #e0f2fe; color: #0369a1; }
    .badge-cashier { background: #fef3c7; color: #92400e; }
    .badge-admin { background: #f1f5f9; color: #475569; }
    .btn-delete { background: #fee2e2; color: #b91c1c; border: none; padding: 8px 12px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
    .btn-delete:hover { background: #fecaca; transform: translateY(-1px); }
</style>

<div class="dashboard-header">
    <h2>User Management</h2>
    <p>Create and manage Doctor, Cashier, and Admin accounts.</p>
</div>

<div class="row">
    <div class="col-md-4">
        <div class="auth-card" style="max-width: 100%;">
            <h3>Add New Staff</h3>
            <% if (request.getParameter("error") != null) { %>
                <div class="error" style="background:#ffebee; color:#c62828; padding:10px; border-radius:5px; margin-bottom:15px; text-align:center;">
                    <% if("InvalidEmail".equals(request.getParameter("error"))) { %>
                        Username must end with <strong>@gmail.com</strong>
                    <% } else if("UsernameExists".equals(request.getParameter("error"))) { %>
                        Username already exists!
                    <% } else { %>
                        Registration Failed!
                    <% } %>
                </div>
            <% } %>
            <% if (request.getParameter("msg") != null) { %>
                <div style="background:#e8f5e9; color:#2e7d32; padding:10px; border-radius:5px; margin-bottom:15px; text-align:center;">
                    Account Created Successfully!
                </div>
            <% } %>
            <form action="UserServlet" method="post">
                <input type="hidden" name="action" value="register">
                <input type="hidden" name="source" value="ADMIN">

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" required>
                </div>
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required>
                </div>
                <div class="form-group">
                    <label>Assign Role</label>
                    <select name="role">
                        <option value="DOCTOR">DOCTOR</option>
                        <option value="CASHIER">CASHIER</option>
                        <option value="ADMIN">ADMIN</option>
                    </select>
                </div>
                <button type="submit" class="btn-primary" style="width:100%;">Create Account</button>
            </form>
        </div>
    </div>

    <div class="col-md-8">
        <div class="auth-card" style="max-width: 100%;">
            <h3>Current System Users</h3>
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        UserDAO dao = new UserDAO();
                        List<User> userList = dao.getAllUsers();
                        for(User u : userList) {
                            String badgeClass = "badge-admin";
                            if("DOCTOR".equals(u.getRole())) badgeClass = "badge-doctor";
                            else if("CASHIER".equals(u.getRole())) badgeClass = "badge-cashier";
                    %>
                    <tr>
                        <td style="font-weight: 600;"><%= u.getFullName() %></td>
                        <td style="color: #64748b;"><%= u.getUsername() %></td>
                        <td><span class="badge <%= badgeClass %>"><%= u.getRole() %></span></td>
                        <td>
                            <form action="UserServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this user?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= u.getId() %>">
                                <button type="submit" class="btn-delete">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
