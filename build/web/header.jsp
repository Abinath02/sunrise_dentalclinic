<%@ page import="com.sunrisedental.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Sunrise Dental Clinic</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
<header>
    <h1>Sunrise Dental Clinic</h1>
    <p>Welcome, <%= user.getFullName() %> (<%= user.getRole() %>)</p>
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
        <li><a href="help.jsp">Help</a></li>
        <li><a href="logout.jsp">Logout</a></li>
    </ul>
</nav>
<div class="container">
