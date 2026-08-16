<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sunrise Dental Clinic</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    
    <style>
        /* Professional Internal Styles (You can move this to your style.css) */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }

        .auth-container {
            width: 100%;
            max-width: 420px;
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

        .error-alert {
            background-color: #fef2f2;
            color: #b91c1c;
            padding: 10px 15px;
            border-radius: 6px;
            font-size: 14px;
            margin-bottom: 20px;
            border: 1px solid #f87171;
            text-align: left;
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
            
            <!-- Professional SVG Dental Icon -->
            <div class="brand-icon">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 21c-2.427-1.127-3.921-3.666-4.945-6.19C6.444 13.313 6 12.062 6 11c0-3.314 2.686-6 6-6s6 2.686 6 6c0 1.062-.444 2.313-1.055 3.81C15.921 17.334 14.427 19.873 12 21z"></path>
                    <path d="M12 11v4"></path>
                    <path d="M10 13h4"></path>
                </svg>
            </div>
            
            <h1 class="brand-title">Sunrise Dental</h1>
            <p class="brand-tagline">Your Smile, Our Priority</p>

            <!-- Error Message Block -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-alert">
                    ⚠️ <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <!-- Login Form -->
            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required autocomplete="username">
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required autocomplete="current-password">
                </div>
                
                <button type="submit" class="btn-primary">Sign In</button>
            </form>

            <!-- Footer Link -->
            <div class="auth-footer">
                New to our clinic? <a href="signup.jsp">Register as Patient</a>
            </div>
            
        </div>
    </div>
</body>
</html>