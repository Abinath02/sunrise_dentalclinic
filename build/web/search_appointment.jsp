<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, com.sunrisedental.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    String userRole = (loggedInUser != null) ? loggedInUser.getRole() : "GUEST";
%>

<div class="row mb-4">
    <div class="col-12">
        <div class="welcome-section text-center" style="border-left: none; border-bottom: 5px solid var(--primary);">
            <h2 style="font-weight: 700;">Patient Records Search</h2>
            <p style="color: var(--text-muted);">Find appointments and update treatment status.</p>
        </div>
    </div>
</div>

<div class="row justify-content-center mb-4">
    <div class="col-6">
        <div class="card">
            <div class="card-body">
                <form action="search_appointment.jsp" method="get">
                    <div class="form-group">
                        <label class="form-label">Appointment Number</label>
                        <input type="text" name="appNumber" class="form-control" placeholder="Search by ID (e.g. APP101)" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Find Record</button>
                </form>
            </div>
        </div>
    </div>
</div>

<%
    String appNumber = request.getParameter("appNumber");
    if (appNumber != null && !appNumber.trim().isEmpty()) {
        AppointmentDAO dao = new AppointmentDAO();
        Appointment app = dao.getAppointment(appNumber.trim());
        if (app != null) {
%>
<div class="row justify-content-center">
    <div class="col-8">
        <div class="card">
            <div class="card-header">Details for <%= app.getAppointmentNumber() %></div>
            <div class="card-body">
                <div class="row">
                    <div class="col-8">
                        <table class="table">
                            <tr><td><strong>Patient</strong></td><td><%= app.getPatientName() %></td></tr>
                            <tr><td><strong>Doctor</strong></td><td>Dr. <%= app.getDentistName() %></td></tr>
                            <tr><td><strong>Treatment</strong></td><td style="font-size: 0.85rem;"><%= app.getTreatmentType() %></td></tr>
                            <tr><td><strong>Date</strong></td><td><%= app.getAppointmentDate() %></td></tr>
                            <tr>
                                <td><strong>Status</strong></td>
                                <td><span class="badge <%= app.getStatus() %>"><%= app.getStatus() %></span></td>
                            </tr>
                            <tr>
                                <td><strong>Total Bill</strong></td>
                                <td style="font-weight: 700; color: var(--primary);">LKR <%= String.format("%.2f", (app.getConsultationFee() + app.getTreatmentCost())) %></td>
                            </tr>
                        </table>
                    </div>

                    <% if ("ADMIN".equals(userRole) || "CASHIER".equals(userRole)) { %>
                    <div class="col-4">
                        <div style="background: #f8fafc; padding: 1.5rem; border-radius: 12px; border: 1px solid var(--border);">
                            <h4 style="margin-bottom: 1rem; font-size: 1rem; font-weight: 700;">Management</h4>
                            <form action="AppointmentServlet" method="post">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="appNumber" value="<%= app.getAppointmentNumber() %>">

                                <div class="form-group mb-4">
                                    <label class="form-label">Update Status</label>
                                    <select name="status" class="form-control">
                                        <option value="PENDING" <%= "PENDING".equals(app.getStatus()) ? "selected" : "" %>>PENDING</option>
                                        <option value="TREATED" <%= "TREATED".equals(app.getStatus()) ? "selected" : "" %>>TREATED</option>
                                        <option value="PAID" <%= "PAID".equals(app.getStatus()) ? "selected" : "" %>>PAID</option>
                                        <option value="CANCELLED" <%= "CANCELLED".equals(app.getStatus()) ? "selected" : "" %>>CANCELLED</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-dark w-100">Update Status</button>
                            </form>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>
<% } else { %>
    <div style="max-width: 500px; margin: 0 auto; padding: 1.5rem; background: #fee2e2; color: #b91c1c; border-radius: 12px; text-align: center; border: 1px solid #fecaca;">
        <i class="fas fa-search"></i> <strong>Record not found!</strong> No appointment matches the ID "<%= appNumber %>".
    </div>
<% }
} %>

<%@ include file="footer.jsp" %>
