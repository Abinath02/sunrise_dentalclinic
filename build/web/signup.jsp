<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Sunrise Dental Clinic</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body style="background: #f0f4f8;">

<div class="auth-container">
    <div class="auth-card">
        <!-- Left Panel (Brand Info) -->
        <div class="auth-info">
            <img src="Logo.jpg" alt="Logo" style="width: 80px; height: 80px; border-radius: 50%; border: 3px solid white; margin-bottom: 2rem;">
            <h1 style="font-weight: 700; margin-bottom: 1.5rem;">Join Sunrise Dental</h1>
            
            <div style="margin-bottom: 1.5rem;">
                <h5 style="color: #0ea5e9; margin-bottom: 0.5rem;"><i class="fas fa-heart"></i> Patient Care</h5>
                <p style="font-size: 0.85rem; opacity: 0.8;">Register to book appointments, track your dental history, and receive digital receipts.</p>
            </div>
            
            <div style="margin-bottom: 1.5rem;">
                <h5 style="color: #0ea5e9; margin-bottom: 0.5rem;"><i class="fas fa-shield-halved"></i> Secure Portal</h5>
                <p style="font-size: 0.85rem; opacity: 0.8;">Your medical data and personal information are protected with industry-standard encryption.</p>
            </div>

            <div style="margin-top: auto; padding-top: 1.5rem; border-top: 1px solid rgba(255,255,255,0.2);">
                <p style="font-size: 0.8rem;"><i class="fas fa-clinic-medical"></i> Quality Care for Your Perfect Smile</p>
            </div>
        </div>

        <!-- Right Panel (Registration Form) -->
        <div class="auth-form">
            <h2 style="font-weight: 700; color: var(--dark); margin-bottom: 1rem;">Create Account</h2>
            <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 2rem;">Please fill in your details to get started.</p>

            <%-- Alert Messages (Backend response) --%>
            <% if (request.getParameter("error") != null) { %>
                <div style="background: #fee2e2; color: #b91c1c; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.9rem;">
                    <i class="fas fa-exclamation-triangle"></i> <%= request.getParameter("error") %>
                </div>
            <% } %>

            <form action="UserServlet" method="post">
                <!-- Hidden fields for backend processing -->
                <input type="hidden" name="action" value="register">
                <input type="hidden" name="role" value="PATIENT">

                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="fullName" class="form-control" placeholder="e.g. John Doe" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-control" placeholder="Choose a username" required>
                </div>
                
                <div class="form-group" style="margin-bottom: 2rem;">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Create a strong password" required>
                </div>

                <button type="submit" class="btn btn-primary w-100" style="padding: 1rem;">Create Patient Account</button>
            </form>

            <div style="text-align: center; margin-top: 1.5rem;">
                <p style="font-size: 0.9rem; color: var(--text-muted);">Already have an account? <a href="login.jsp" style="color: var(--primary); font-weight: 700; text-decoration: none;">Login here</a></p>
            </div>
        </div>
    </div>
</div>

</body>
</html>
