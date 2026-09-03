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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental Clinic</title>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="container navbar-container">
        <a class="navbar-brand" href="#">
            <img src="Logo.jpg" alt="Logo">
            <span>Sunrise Dental</span>
        </a>
        <ul class="nav-links">
            <% if ("ADMIN".equals(user.getRole())) { %>
                <li><a href="admin_dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
            <% } else if ("DOCTOR".equals(user.getRole())) { %>
                <li><a href="doctor_dashboard.jsp"><i class="fas fa-user-md"></i> Dashboard</a></li>
            <% } else if ("CASHIER".equals(user.getRole())) { %>
                <li><a href="cashier_dashboard.jsp"><i class="fas fa-cash-register"></i> Dashboard</a></li>
            <% } else if ("PATIENT".equals(user.getRole())) { %>
                <li><a href="patient_dashboard.jsp"><i class="fas fa-user"></i> Dashboard</a></li>
            <% } %>

            <% if ("ADMIN".equals(user.getRole()) || "CASHIER".equals(user.getRole()) || "PATIENT".equals(user.getRole())) { %>
                <li><a href="register_appointment.jsp"><i class="fas fa-calendar-plus"></i> New</a></li>
            <% } %>

            <% if ("ADMIN".equals(user.getRole()) || "CASHIER".equals(user.getRole())) { %>
                <li><a href="appointment_history.jsp"><i class="fas fa-history"></i> History</a></li>
                <li><a href="search_appointment.jsp"><i class="fas fa-search"></i> Search</a></li>
            <% } %>

            <% if ("ADMIN".equals(user.getRole())) { %>
                <li><a href="manage_users.jsp"><i class="fas fa-users-cog"></i> Users</a></li>
            <% } %>

            <li class="nav-user"><i class="fas fa-circle-user"></i> <%= user.getFullName() %></li>
            <li><a href="logout.jsp" class="btn-outline-danger btn">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container py-4">
