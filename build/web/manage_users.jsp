<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.dao.UserDAO, com.sunrisedental.model.User, java.util.List" %>
<%@ page import="com.sunrisedental.dao.UserDAO, com.sunrisedental.model.User, java.util.List" %>
<%@ include file="header.jsp" %>

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
                    %>
                    <tr>
                        <td><%= u.getFullName() %></td>
                        <td><%= u.getUsername() %></td>
                        <td><span class="badge" style="background:#34495e; color:white;"><%= u.getRole() %></span></td>
                        <td>
                            <form action="UserServlet" method="post" onsubmit="return confirm('Are you sure?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= u.getId() %>">
                                <button type="submit" class="btn-sm" style="background: #e74c3c; color:white; border:none; padding:5px 10px; border-radius:5px;">Delete</button>
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
