<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental Clinic | Welcome</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/all.min.css">
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body style="background: #f0f4f8;">

<div class="auth-container">
    <div class="auth-card">
        <!-- Left Panel -->
        <div class="auth-info">
            <img src="Logo.jpg" alt="Logo" style="width: 80px; height: 80px; border-radius: 50%; border: 3px solid white; margin-bottom: 2rem;">
            <h1 style="font-weight: 700; margin-bottom: 1.5rem;">Sunrise Dental Clinic</h1>

            <div style="margin-bottom: 1.5rem;">
                <h5 style="color: #0ea5e9; margin-bottom: 0.5rem;"><i class="fas fa-eye"></i> Our Vision</h5>
                <p style="font-size: 0.85rem; opacity: 0.8;">To redefine dental care excellence through innovation and compassionate service.</p>
            </div>

            <div style="margin-bottom: 1.5rem;">
                <h5 style="color: #0ea5e9; margin-bottom: 0.5rem;"><i class="fas fa-bullseye"></i> Our Mission</h5>
                <p style="font-size: 0.85rem; opacity: 0.8;">To provide high-quality, accessible, and pain-free dental treatments to our community.</p>
            </div>

            <div style="margin-top: auto; padding-top: 1.5rem; border-top: 1px solid rgba(255,255,255,0.2);">
                <p style="font-size: 0.8rem;"><i class="fas fa-map-marker-alt"></i> No 69, Gotham City, Jaffna</p>
            </div>
        </div>

        <!-- Right Panel -->
        <div class="auth-form">
            <h2 style="font-weight: 700; color: var(--dark); margin-bottom: 2rem;">Welcome Back</h2>

            <% if (request.getAttribute("error") != null) { %>
                <div style="background: #fee2e2; color: #b91c1c; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.9rem;">
                    <i class="fas fa-exclamation-triangle"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="login" method="post">
                <div class="form-group">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-control" placeholder="Enter your username" required>
                </div>
                <div class="form-group" style="margin-bottom: 2rem;">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>
                <button type="submit" class="btn btn-primary w-100" style="padding: 1rem;">Sign In</button>
            </form>

            <div style="text-align: center; margin-top: 1.5rem;">
                <p style="font-size: 0.9rem; color: var(--text-muted);">New patient? <a href="signup.jsp" style="color: var(--primary); font-weight: 700; text-decoration: none;">Register here</a></p>
            </div>

            <div style="margin-top: 3rem; padding: 1.5rem; background: #f8fafc; border-radius: 12px; border: 1px dashed #cbd5e1; font-size: 0.8rem; color: var(--text-muted);">
                <h6 style="color: var(--dark); font-weight: 700; margin-bottom: 0.5rem;">Patient Guide</h6>
                <ul style="padding-left: 1rem;">
                    <li>Create account and login to book.</li>
                    <li>1,000 LKR fee applies for booking.</li>
                    <li>Check email for appointment bill.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

</body>
</html>
