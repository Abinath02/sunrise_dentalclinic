<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental Clinic | Welcome</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Poppins', sans-serif; background: #f0f4f8; display: flex; align-items: center; justify-content: center; min-height: 100vh; padding: 20px; }

        /* Main Container */
        .page-wrapper { display: flex; width: 100%; max-width: 1000px; background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.1); }

        /* Left Side: Brand & Info */
        .info-panel { flex: 1; background: #2563eb; color: white; padding: 50px; display: flex; flex-direction: column; justify-content: center; }
        .logo-img { width: 120px; height: 120px; object-fit: cover; border-radius: 50%; border: 4px solid white; margin-bottom: 20px; }
        .info-panel h2 { font-size: 32px; margin-bottom: 20px; }
        .info-panel h4 { margin-top: 20px; opacity: 0.9; }
        .info-panel p { font-size: 14px; opacity: 0.8; line-height: 1.6; margin-top: 10px; }
        .location-section { margin-top: auto; padding-top: 20px; font-weight: 600; font-size: 15px; }

        /* Right Side: Login Form */
        .login-panel { flex: 1; padding: 50px; display: flex; flex-direction: column; justify-content: center; }
        .login-title { font-size: 28px; color: #0f172a; margin-bottom: 30px; font-weight: 700; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; }
        .form-group input { width: 100%; padding: 14px; border: 1px solid #e2e8f0; border-radius: 10px; }
        .btn-primary { width: 100%; background: #2563eb; color: white; padding: 14px; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: 0.3s; }
        .btn-primary:hover { background: #1d4ed8; }
    </style>
</head>
<body>

<div class="page-wrapper">
    <!-- Left Panel -->
    <div class="info-panel">
        <img src="Logo.jpg" alt="Logo" class="logo-img">
        <h2>Sunrise Dental Clinic</h2>
        
        <h4>Our Vision</h4>
        <p>To redefine dental care excellence through innovation and compassionate service.</p>
        
        <h4>Our Mission</h4>
        <p>To provide high-quality, accessible, and pain-free dental treatments to our community.</p>

        <div class="location-section">
            📍 No 69, Gotham City, Jaffna
        </div>
    </div>

    <!-- Right Panel -->
    <div class="login-panel">
        <h1 class="login-title">Login to Account</h1>
        
        <% if (request.getAttribute("error") != null) { %>
            <div style="color: #b91c1c; background: #fee2e2; padding: 10px; border-radius: 8px; margin-bottom: 20px;">
                ⚠️ <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="login" method="post">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Enter your username" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn-primary">Sign In</button>
        </form>
        
        <p style="margin-top: 20px; font-size: 14px; text-align: center;">
            New patient? <a href="signup.jsp" style="color: #2563eb; font-weight: 600;">Register here</a>
        </p>

        <!-- Patient User Guide -->
        <div style="margin-top: 40px; padding: 20px; background: #f8fafc; border-radius: 12px; border: 1px dashed #cbd5e1;">
            <h3 style="font-size: 16px; color: #1e293b; margin-bottom: 10px; display: flex; align-items: center; gap: 8px;">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                Simple Patient Guide
            </h3>
            <ul style="font-size: 13px; color: #64748b; list-style: none; padding: 0;">
                <li style="margin-bottom: 8px;"><strong>Step 1:</strong> Create an account using the "Register" link above.</li>
                <li style="margin-bottom: 8px;"><strong>Step 2:</strong> Login and click "New Appointment" to book your visit.</li>
                <li style="margin-bottom: 8px;"><strong>Step 3:</strong> Pay the 1,000 LKR booking fee via card to secure your slot.</li>
                <li><strong>Step 4:</strong> Check your email for the confirmation bill and visit on your scheduled time.</li>
            </ul>
        </div>
    </div>
</div>

</body>
</html>