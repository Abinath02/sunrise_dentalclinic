<%@ page import="com.sunrisedental.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<div class="container">
    <div class="dashboard-header">
        <h2>Book Your Appointment</h2>
        <p>Choose your specialist and preferred time for consultation.</p>
    </div>

    <div class="auth-card" style="max-width: 700px; margin: 0 auto;">
        <form action="AppointmentServlet" method="post">
            <div class="row">
                <div class="form-group" style="flex:1;">
                    <label>Appointment ID (Auto-suggested)</label>
                    <%-- Simple random ID for professional feel --%>
                    <input type="text" name="appNumber" value="APP<%= (int)(Math.random()*9000)+1000 %>" readonly style="background:#eee;">
                </div>
                <div class="form-group" style="flex:1;">
                    <label>Patient Name</label>
                    <input type="text" name="patientName" value="<%= user.getFullName() %>" <%= "PATIENT".equals(user.getRole()) ? "readonly" : "" %> required>
                </div>
            </div>

            <div class="form-group">
                <label>Contact Number</label>
                <input type="text" name="contact" placeholder="Enter your phone number" required>
            </div>

            <div class="row">
                <div class="form-group" style="flex:1;">
                    <label>Choose Specialist</label>
                    <select name="dentist">
                        <option value="Mr.A.Johny">Mr.A.Johny (Orthodontist)</option>
                        <option value="Miss.A.Thulashi">Miss.A.Thulashi (General)</option>
                        <option value="Mr.S.Ajith">Mr.S.Ajith (Oral Surgeon)</option>
                        <option value="Mr.A.Hitler">Mr.A.Hitler (Periodontist)</option>
                    </select>
                </div>
                <div class="form-group" style="flex:1;">
                    <label>Treatment Type</label>
                    <select name="treatment">
                        <option value="General Checkup">General Checkup</option>
                        <option value="Cleaning">Cleaning</option>
                        <option value="Filling">Filling</option>
                        <option value="Extraction">Extraction</option>
                        <option value="Root Canal">Root Canal</option>
                    </select>
                </div>
            </div>

            <div class="row">
                <div class="form-group" style="flex:1;">
                    <label>Preferred Date</label>
                    <input type="date" name="date" required min="<%= new java.sql.Date(System.currentTimeMillis()) %>">
                </div>
                <div class="form-group" style="flex:1;">
                    <label>Preferred Time</label>
                    <input type="time" name="time" required>
                </div>
            </div>

            <%-- Hidden fee fields for Patients, visible for Staff --%>
            <% if ("PATIENT".equals(user.getRole())) { %>
                <input type="hidden" name="consultationFee" value="1000.00">
                <input type="hidden" name="treatmentCost" value="0.00">
                <p style="color:#7f8c8d; font-size:13px;">* Standard consultation fee of LKR 1000.00 applies.</p>
            <% } else { %>
                <div class="row">
                    <div class="form-group" style="flex:1;">
                        <label>Consultation Fee</label>
                        <input type="number" name="consultationFee" value="1000.00">
                    </div>
                    <div class="form-group" style="flex:1;">
                        <label>Initial Treatment Cost</label>
                        <input type="number" name="treatmentCost" value="0.00">
                    </div>
                </div>
            <% } %>

            <button type="submit" class="btn-primary" style="width:100%; margin-top:10px;">Confirm Appointment</button>
        </form>
    </div>
</div>

<%@ include file="footer.jsp" %>
