<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.dao.UserDAO, com.sunrisedental.model.User, java.util.List" %>
<%@ include file="header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="welcome-section">
            <h2 style="font-weight: 700; color: var(--dark);">User Management</h2>
            <p style="color: var(--text-muted);">Create and manage Doctor, Cashier, and Admin accounts across the system.</p>
        </div>
    </div>
</div>

<div class="row">
    <!-- Left Column: Add User Form -->
    <div class="col-4">
        <div class="card">
            <div class="card-header">Add New Staff</div>
            <div class="card-body">
                <%-- Alert Messages --%>
                <% if (request.getParameter("error") != null) { %>
                    <div style="background: #fee2e2; color: #b91c1c; padding: 0.8rem; border-radius: 8px; margin-bottom: 1rem; font-size: 0.8rem; border: 1px solid #fecaca;">
                        <% if("InvalidEmail".equals(request.getParameter("error"))) { %>
                            Username must end with <strong>@gmail.com</strong>
                        <% } else if("UsernameExists".equals(request.getParameter("error"))) { %>
                            This username already exists!
                        <% } else { %>
                            Registration failed. Please try again.
                        <% } %>
                    </div>
                <% } %>

                <% if (request.getParameter("msg") != null) { %>
                    <div style="background: #dcfce7; color: #166534; padding: 0.8rem; border-radius: 8px; margin-bottom: 1rem; font-size: 0.8rem; border: 1px solid #bbf7d0;">
                        ✓ Account created successfully!
                    </div>
                <% } %>

                <form action="UserServlet" method="post">
                    <input type="hidden" name="action" value="register">
                    <input type="hidden" name="source" value="ADMIN">

                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="fullName" class="form-control" placeholder="Dr. John Doe" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email / Username</label>
                        <input type="text" name="username" class="form-control" placeholder="johndoe@gmail.com" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Temporary Password</label>
                        <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                    </div>

                    <div class="form-group mb-4">
                        <label class="form-label">Assign Role</label>
                        <select name="role" class="form-control" required>
                            <option value="" disabled selected>Select a role...</option>
                            <option value="DOCTOR">Doctor</option>
                            <option value="CASHIER">Cashier</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">Create Account</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: User List Table -->
    <div class="col-8">
        <div class="card">
            <div class="card-header">Current System Users</div>
            <div class="card-body" style="padding: 0;">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="padding-left: 1.5rem;">Name</th>
                                <th>Username</th>
                                <th>Role</th>
                                <th style="text-align: right; padding-right: 1.5rem;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    UserDAO dao = new UserDAO();
                                    List<User> userList = dao.getAllUsers();

                                    if (userList != null && !userList.isEmpty()) {
                                        for(User u : userList) {
                                            String badgeStyle = "background: #f1f5f9; color: #475569;";
                                            if("DOCTOR".equals(u.getRole())) badgeStyle = "background: #e0f2fe; color: #0369a1;";
                                            else if("CASHIER".equals(u.getRole())) badgeStyle = "background: #fef3c7; color: #92400e;";
                            %>
                            <tr>
                                <td style="padding-left: 1.5rem; font-weight: 600;"><%= u.getFullName() %></td>
                                <td style="color: var(--text-muted);"><%= u.getUsername() %></td>
                                <td><span class="badge" style="<%= badgeStyle %>"><%= u.getRole() %></span></td>
                                <td style="text-align: right; padding-right: 1.5rem;">
                                    <form action="UserServlet" method="post" style="margin:0;" onsubmit="return confirm('Are you sure you want to remove <%= u.getFullName() %>?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= u.getId() %>">
                                        <button type="submit" class="btn btn-outline-danger">Remove</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                        }
                                    } else {
                            %>
                            <tr>
                                <td colspan="4" style="text-align: center; padding: 2rem; color: var(--text-muted);">No users found.</td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
