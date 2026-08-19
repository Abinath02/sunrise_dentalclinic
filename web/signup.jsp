<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Sunrise Dental Clinic</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    
    <style>
        /* Professional Internal Styles (Matches Login Page) */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 20px 0;
        }

        .auth-container {
            width: 100%;
            max-width: 450px; /* Slightly wider for registration */
            padding: 20px;
        }

        .auth-card {
            background: #ffffff;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        .brand-icon {
            margin-bottom: 15px;
        }

        .brand-title {
            margin: 0;
            color: #0f172a;
            font-size: 26px;
            font-weight: 600;
            letter-spacing: -0.5px;
        }

        .brand-tagline {
            color: #64748b;
            font-size: 14px;
            margin-top: 5px;
            margin-bottom: 30px;
        }

        .form-group {
            text-align: left;
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            color: #334155;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            box-sizing: border-box;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .btn-primary {
            width: 100%;
            background-color: #2563eb;
            color: #ffffff;
            border: none;
            padding: 12px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-family: 'Poppins', sans-serif;
            margin-top: 10px;
        }

        .btn-primary:hover {
            background-color: #1d4ed8;
        }

        .auth-footer {
            margin-top: 25px;
            color: #64748b;
            font-size: 14px;
        }

        .auth-footer a {
            color: #2563eb;
            text-decoration: none;
            font-weight: 500;
        }

        .auth-footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            
            <!-- Professional Logo -->
            <div class="brand-icon">
                <img src="Logo.jpg" alt="Logo" style="width: 100px; height: 100px; border-radius: 50%; border: 3px solid #2563eb; object-fit: cover;">
            </div>
            
            <h1 class="brand-title">Join Sunrise Dental</h1>
            <p class="brand-tagline">Professional Dental Care for You & Your Family</p>

            <!-- Registration Form -->
            <form action="UserServlet" method="post">
                <!-- Hidden fields for backend processing -->
                <input type="hidden" name="action" value="register">
                <input type="hidden" name="role" value="PATIENT">

                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" placeholder="e.g. John Doe" required autocomplete="name">
                </div>
                
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="Choose a username" required autocomplete="username">
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Create a strong password" required new-password">
                </div>

                <button type="submit" class="btn-primary">Create Patient Account</button>
            </form>

            <!-- Footer Link -->
            <div class="auth-footer">
                Already have an account? <a href="login.jsp">Login here</a>
            </div>
            
        </div>
    </div>
</body>
</html>