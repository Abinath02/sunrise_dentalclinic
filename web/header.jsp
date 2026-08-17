<%@ page import="com.sunrisedental.model.User" %>
<%
    // Prevent browser from caching protected pages
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.

    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sunrise Dental Clinic</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
<header>
    <h1>Sunrise Dental Clinic</h1>
    <div class="user-info">
        <span>Welcome, <%= user.getFullName() %> (<%= user.getRole() %>)</span>
    </div>
</header>
<nav>
    <ul>
        <% if ("ADMIN".equals(user.getRole())) { %>
            <li><a href="admin_dashboard.jsp">Dashboard</a></li>
        <% } else if ("DOCTOR".equals(user.getRole())) { %>
            <li><a href="doctor_dashboard.jsp">Dashboard</a></li>
        <% } else if ("CASHIER".equals(user.getRole())) { %>
            <li><a href="cashier_dashboard.jsp">Dashboard</a></li>
        <% } else if ("PATIENT".equals(user.getRole())) { %>
            <li><a href="patient_dashboard.jsp">Dashboard</a></li>
        <% } %>

        <% if ("ADMIN".equals(user.getRole()) || "CASHIER".equals(user.getRole()) || "PATIENT".equals(user.getRole())) { %>
            <li><a href="register_appointment.jsp">New Appointment</a></li>
        <% } %>

        <% if ("ADMIN".equals(user.getRole()) || "CASHIER".equals(user.getRole())) { %>
            <li><a href="appointment_history.jsp">Appointment History</a></li>
            <li><a href="search_appointment.jsp">Database Search</a></li>
        <% } %>

        <% if ("ADMIN".equals(user.getRole())) { %>
            <li><a href="manage_users.jsp">Staff Management</a></li>
        <% } %>

        <li><a href="logout.jsp" style="background: #e74c3c; border-radius: 5px;">Logout</a></li>
    </ul>
</nav>
<div class="container">
