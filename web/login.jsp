<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental Clinic | Welcome</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f0f4f8;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .login-card {
            border: none;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            max-width: 1000px;
            width: 100%;
        }
        .info-panel {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: white;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .login-panel {
            background: white;
            padding: 60px;
        }
        .form-control {
            border-radius: 10px;
            padding: 12px 15px;
            border: 1px solid #e2e8f0;
        }
        .form-control:focus {
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            border-color: #2563eb;
        }
        .btn-primary {
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            background: #2563eb;
            border: none;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }
        .logo-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 3px solid white;
            margin-bottom: 25px;
        }
    </style>
</head>
<body>

<div class="card login-card">
    <div class="row g-0">
        <!-- Left Panel -->
        <div class="col-lg-6 info-panel d-none d-lg-flex">
            <img src="Logo.jpg" alt="Logo" class="logo-circle shadow-sm">
            <h1 class="fw-bold mb-4">Sunrise Dental Clinic</h1>

            <div class="mb-4">
                <h5 class="fw-bold text-info"><i class="fas fa-eye me-2"></i>Our Vision</h5>
                <p class="opacity-75 small">To redefine dental care excellence through innovation and compassionate service.</p>
            </div>

            <div class="mb-4">
                <h5 class="fw-bold text-info"><i class="fas fa-bullseye me-2"></i>Our Mission</h5>
                <p class="opacity-75 small">To provide high-quality, accessible, and pain-free dental treatments to our community.</p>
            </div>

            <div class="mt-auto pt-4 border-top border-white border-opacity-25">
                <p class="mb-0 small"><i class="fas fa-map-marker-alt me-2 text-info"></i> No 69, Gotham City, Jaffna</p>
                <p class="mb-0 small"><i class="fas fa-phone me-2 text-info"></i> +94 11 234 5678</p>
            </div>
        </div>

        <!-- Right Panel -->
        <div class="col-lg-6 login-panel">
            <div class="d-lg-none mb-4 text-center">
                <img src="Logo.jpg" alt="Logo" class="logo-circle shadow-sm" style="width: 60px; height: 60px;">
                <h3 class="fw-bold text-primary">Sunrise Dental</h3>
            </div>

            <h2 class="fw-bold text-dark mb-4">Welcome Back</h2>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <div><%= request.getAttribute("error") %></div>
                </div>
            <% } %>

            <form action="login" method="post">
                <div class="mb-3">
                    <label class="form-label fw-medium">Username</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-user text-muted"></i></span>
                        <input type="text" name="username" class="form-control border-start-0" placeholder="Enter your username" required>
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label fw-medium">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-lock text-muted"></i></span>
                        <input type="password" name="password" class="form-control border-start-0" placeholder="••••••••" required>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary w-100 py-3 mb-3 shadow-sm">Sign In</button>
            </form>

            <div class="text-center">
                <p class="text-muted small mb-0">New patient? <a href="signup.jsp" class="text-primary fw-bold text-decoration-none">Register here</a></p>
            </div>

            <div class="mt-5 p-3 bg-light rounded-4 border border-dashed text-muted" style="font-size: 0.8rem;">
                <h6 class="text-dark fw-bold mb-2"><i class="fas fa-info-circle text-primary me-2"></i>Patient Guide</h6>
                <ul class="ps-3 mb-0">
                    <li class="mb-1">Create account and login to book.</li>
                    <li class="mb-1">1,000 LKR fee applies for booking.</li>
                    <li>Check email for appointment bill.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
