<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.dao.UserDAO, com.sunrisedental.model.User, java.util.List" %>
<%@ include file="header.jsp" %>

<style>
    /* --- Modern Theme Variables --- */
    :root {
        --primary: #2563eb;
        --primary-hover: #1d4ed8;
        --danger: #ef4444;
        --danger-hover: #dc2626;
        --surface: #ffffff;
        --background: #f8fafc;
        --border: #e2e8f0;
        --text-main: #1e293b;
        --text-muted: #64748b;
    }

    /* --- Card & Layout Layout --- */
    .dashboard-header {
        margin-bottom: 25px;
    }
    .dashboard-header h2 {
        color: var(--text-main);
        font-weight: 700;
        margin-bottom: 5px;
    }
    .dashboard-header p {
        color: var(--text-muted);
        font-size: 15px;
    }
    .auth-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 24px;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        margin-bottom: 20px;
    }
    .auth-card h3 {
        margin-top: 0;
        margin-bottom: 20px;
        color: var(--text-main);
        font-size: 18px;
        font-weight: 600;
        border-bottom: 2px solid var(--background);
        padding-bottom: 10px;
    }

    /* --- Form Elements --- */
    .form-group {
        margin-bottom: 16px;
    }
    .form-group label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        color: var(--text-main);
        margin-bottom: 6px;
    }
    .form-control {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid var(--border);
        border-radius: 8px;
        font-size: 14px;
        transition: all 0.2s;
        box-sizing: border-box;
    }
    .form-control:focus {
        border-color: var(--primary);
        outline: none;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }
    .btn-primary {
        background: var(--primary);
        color: #fff;
        border: none;
        padding: 12px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        width: 100%;
        transition: background 0.2s;
    }
    .btn-primary:hover {
        background: var(--primary-hover);
    }

    /* --- Table Styles --- */
    .table-responsive {
        overflow-x: auto;
    }
    .modern-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
    }
    .modern-table th {
        background: var(--background);
        color: var(--text-muted);
        font-weight: 600;
        text-transform: uppercase;
        font-size: 12px;
        letter-spacing: 0.5px;
        padding: 12px 15px;
        text-align: left;
        border-bottom: 2px solid var(--border);
    }
    .modern-table td {
        padding: 15px;
        border-bottom: 1px solid var(--border);
        color: var(--text-main);
        font-size: 14px;
        vertical-align: middle;
    }
    .modern-table tr:last-child td { border-bottom: none; }
    .modern-table tr:hover td { background-color: var(--background); }

    /* --- Badges & Buttons --- */
    .badge {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .badge-doctor { background: #e0f2fe; color: #0369a1; }
    .badge-cashier { background: #fef3c7; color: #92400e; }
    .badge-admin { background: #f1f5f9; color: #475569; }

    .btn-delete {
        background: #fee2e2;
        color: var(--danger);
        border: 1px solid #f87171;
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
    }
    .btn-delete:hover {
        background: var(--danger);
        color: #fff;
    }

    /* --- Alerts --- */
    .alert {
        padding: 12px 15px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-size: 14px;
        font-weight: 500;
    }
    .alert-error { background: #fef2f2; border: 1px solid #fecaca; color: #b91c1c; }
    .alert-success { background: #f0fdf4; border: 1px solid #bbf7d0; color: #15803d; }
    .empty-state { text-align: center; padding: 30px; color: var(--text-muted); font-style: italic; }
</style>

<div class="dashboard-header">
    <h2>User Management</h2>
    <p>Create and manage Doctor, Cashier, and Admin accounts across the system.</p>
</div>

<div class="row">
    <!-- Left Column: Add User Form -->
    <div class="col-md-4">
        <div class="auth-card">
            <h3>Add New Staff</h3>
            
            <%-- Alert Messages --%>
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
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
                <div class="alert alert-success">
                    ✓ Account created successfully!
                </div>
            <% } %>

            <form action="UserServlet" method="post">
                <input type="hidden" name="action" value="register">
                <input type="hidden" name="source" value="ADMIN">

                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" placeholder="Dr. John Doe" required>
                </div>
                
                <div class="form-group">
                    <label for="username">Email / Username</label>
                    <input type="text" id="username" name="username" class="form-control" placeholder="johndoe@gmail.com" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Temporary Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>
                
                <div class="form-group">
                    <label for="role">Assign Role</label>
                    <select id="role" name="role" class="form-control" required>
                        <option value="" disabled selected>Select a role...</option>
                        <option value="DOCTOR">Doctor</option>
                        <option value="CASHIER">Cashier</option>
                        <option value="ADMIN">Admin</option>
                    </select>
                </div>
                
                <button type="submit" class="btn-primary">Create Account</button>
            </form>
        </div>
    </div>

    <!-- Right Column: User List Table -->
    <div class="col-md-8">
        <div class="auth-card">
            <h3>Current System Users</h3>
            
            <div class="table-responsive">
                <table class="modern-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Role</th>
                            <th style="text-align: right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                UserDAO dao = new UserDAO();
                                List<User> userList = dao.getAllUsers();
                                
                                if (userList != null && !userList.isEmpty()) {
                                    for(User u : userList) {
                                        String badgeClass = "badge-admin";
                                        if("DOCTOR".equals(u.getRole())) badgeClass = "badge-doctor";
                                        else if("CASHIER".equals(u.getRole())) badgeClass = "badge-cashier";
                        %>
                        <tr>
                            <td style="font-weight: 600;"><%= u.getFullName() %></td>
                            <td style="color: var(--text-muted);"><%= u.getUsername() %></td>
                            <td><span class="badge <%= badgeClass %>"><%= u.getRole() %></span></td>
                            <td style="text-align: right;">
                                <form action="UserServlet" method="post" style="margin:0;" onsubmit="return confirm('Are you sure you want to remove <%= u.getFullName() %>? This action cannot be undone.')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= u.getId() %>">
                                    <button type="submit" class="btn-delete" title="Delete User">Remove</button>
                                </form>
                            </td>
                        </tr>
                        <% 
                                    } 
                                } else {
                        %>
                        <tr>
                            <td colspan="4" class="empty-state">No users found in the system.</td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='4' class='alert alert-error'>Error loading users: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>