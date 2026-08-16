<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Help - Sunrise Dental</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="dashboard-card">
        <h2>Help & System Instructions</h2>
        <div style="line-height: 1.6;">
            <h3>1. Logging In</h3>
            <p>Use your assigned username and password to log in. Your dashboard features will change based on your role (Admin, Doctor, Patient, or Cashier).</p>

            <h3>2. Registering an Appointment</h3>
            <p>Go to the <strong>New Appointment</strong> section. Fill in all details including the patient's name, treatment type, and scheduled time. Ensure the Appointment Number is unique.</p>

            <h3>3. Searching for Appointments</h3>
            <p>Use the search bar in your dashboard to find patient records using their unique Appointment Number.</p>

            <h3>4. Generating Bills</h3>
            <p>Cashiers can enter the Appointment Number in the Billing section to generate a professional receipt. Each receipt includes a QR code containing the patient's payment summary.</p>

            <h3>5. Security</h3>
            <p>Always log out when you are finished using the system to protect patient privacy.</p>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
