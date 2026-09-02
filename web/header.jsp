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
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="#">
            <img src="Logo.jpg" alt="Logo" width="40" height="40" class="rounded-circle border border-2 border-white me-2">
            <span class="fw-bold">Sunrise Dental</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <% if ("ADMIN".equals(user.getRole())) { %>
                    <li class="nav-item"><a class="nav-link" href="admin_dashboard.jsp"><i class="fas fa-home me-1"></i> Dashboard</a></li>
                <% } else if ("DOCTOR".equals(user.getRole())) { %>
                    <li class="nav-item"><a class="nav-link" href="doctor_dashboard.jsp"><i class="fas fa-user-md me-1"></i> Dashboard</a></li>
                <% } else if ("CASHIER".equals(user.getRole())) { %>
                    <li class="nav-item"><a class="nav-link" href="cashier_dashboard.jsp"><i class="fas fa-cash-register me-1"></i> Dashboard</a></li>
                <% } else if ("PATIENT".equals(user.getRole())) { %>
                    <li class="nav-item"><a class="nav-link" href="patient_dashboard.jsp"><i class="fas fa-user me-1"></i> Dashboard</a></li>
                <% } %>

                <% if ("ADMIN".equals(user.getRole()) || "CASHIER".equals(user.getRole()) || "PATIENT".equals(user.getRole())) { %>
                    <li class="nav-item"><a class="nav-link" href="register_appointment.jsp"><i class="fas fa-calendar-plus me-1"></i> New Appointment</a></li>
                <% } %>

                <% if ("ADMIN".equals(user.getRole()) || "CASHIER".equals(user.getRole())) { %>
                    <li class="nav-item"><a class="nav-link" href="appointment_history.jsp"><i class="fas fa-history me-1"></i> History</a></li>
                    <li class="nav-item"><a class="nav-link" href="search_appointment.jsp"><i class="fas fa-search me-1"></i> Search</a></li>
                <% } %>

                <% if ("ADMIN".equals(user.getRole())) { %>
                    <li class="nav-item"><a class="nav-link" href="manage_users.jsp"><i class="fas fa-users-cog me-1"></i> Users</a></li>
                <% } %>
            </ul>
            <div class="d-flex align-items-center">
                <span class="text-light me-3 small d-none d-md-inline">
                    <i class="fas fa-circle-user me-1 text-info"></i> <%= user.getFullName() %>
                </span>
                <a href="logout.jsp" class="btn btn-outline-danger btn-sm">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="container py-4">
