<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment" %>
<%-- Added User model import. Adjust the package name based on your project --%>
<%@ page import="com.sunrisedental.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<%
    // 1. FIX: Fetch the user from the session to avoid NullPointerException
    User loggedInUser = (User) session.getAttribute("user");
    String userRole = (loggedInUser != null) ? loggedInUser.getRole() : "GUEST";
%>

<div class="container">
    <div class="dashboard-header">
        <h2>Patient Records & Management</h2>
        <p>Find appointments and update treatment status.</p>
    </div>

    <div class="auth-card" style="max-width: 500px; margin: 0 auto 30px auto;">
        <form action="search_appointment.jsp" method="get">
            <div class="form-group">
                <label for="appNumber">Appointment Number</label>
                <input type="text" id="appNumber" name="appNumber" placeholder="Search by ID (e.g. APP101)" required>
            </div>
            <button type="submit" class="btn-primary" style="width:100%;">Find Record</button>
        </form>
    </div>

    <%
        String appNumber = request.getParameter("appNumber");
        // 2. FIX: Check for both null AND empty strings before querying the DB
        if (appNumber != null && !appNumber.trim().isEmpty()) {
            AppointmentDAO dao = new AppointmentDAO();
            Appointment app = dao.getAppointment(appNumber.trim());

            if (app != null) {
    %>
    <div class="auth-card" style="max-width: 900px; margin: 0 auto;">
        <div class="row">
            <div class="col-8">
                <h3>Details for <%= app.getAppointmentNumber() %></h3>
                <table style="width: 100%;" class="table">
                    <tr><td><strong>Patient</strong></td><td><%= app.getPatientName() %></td></tr>
                    <tr><td><strong>Doctor</strong></td><td><%= app.getDentistName() %></td></tr>
                    <tr><td><strong>Treatment</strong></td><td><%= app.getTreatmentType() %></td></tr>
                    <tr><td><strong>Date</strong></td><td><%= app.getAppointmentDate() %></td></tr>
                    <tr>
                        <td><strong>Status</strong></td>
                        <%-- 3. FIX: Added dynamic badge class for better styling (e.g., badge-pending, badge-paid) --%>
                        <td><span class="badge badge-<%= app.getStatus().toLowerCase() %>"><%= app.getStatus() %></span></td>
                    </tr>
                    <tr>
                        <td><strong>Total Bill</strong></td>
                        <td><strong>LKR <%= String.format("%.2f", (app.getConsultationFee() + app.getTreatmentCost())) %></strong></td>
                    </tr>
                </table>
            </div>
            
            <%-- 4. FIX: Securely check the role using the variable initialized at the top --%>
            <% if ("ADMIN".equals(userRole) || "CASHIER".equals(userRole)) { %>
            <div class="col-4">
                <div style="background:#f8f9fa; padding:20px; border-radius:10px;">
                    <h4>Management</h4>
                    <form action="AppointmentServlet" method="post">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="appNumber" value="<%= app.getAppointmentNumber() %>">
                        
                        <div class="form-group">
                            <label for="statusSelect" style="display:none;">Update Status</label>
                            <select name="status" id="statusSelect" class="form-control" style="width:100%; margin-bottom:15px;">
                                <option value="PENDING" <%= "PENDING".equals(app.getStatus()) ? "selected" : "" %>>PENDING</option>
                                <option value="TREATED" <%= "TREATED".equals(app.getStatus()) ? "selected" : "" %>>TREATED</option>
                                <option value="PAID" <%= "PAID".equals(app.getStatus()) ? "selected" : "" %>>PAID</option>
                                <option value="CANCELLED" <%= "CANCELLED".equals(app.getStatus()) ? "selected" : "" %>>CANCELLED</option>
                            </select>
                        </div>
                        <button type="submit" class="btn-primary" style="width:100%; background:#2c3e50;">Update Status</button>
                    </form>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    <% } else { %>
        <%-- 5. FIX: Better UI for error message --%>
        <div class="error-alert" style="max-width:500px; margin:0 auto; padding:15px; background:#ffebee; color:#c62828; border-radius:5px; text-align:center;">
            <strong>Record not found!</strong> No appointment matches the ID "<%= appNumber %>".
        </div>
    <% } 
    } %>
</div>

<%@ include file="footer.jsp" %>