<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="welcome-section text-center" style="border-left: none; border-bottom: 5px solid var(--primary);">
            <h2 style="font-weight: 700;">Appointment History</h2>
            <p style="color: var(--text-muted);">Filter and view patient appointments by date.</p>
        </div>
    </div>
</div>

<div class="row justify-content-center mb-4">
    <div class="col-6">
        <div class="card">
            <div class="card-body">
                <form action="appointment_history.jsp" method="get">
                    <div class="form-group">
                        <label class="form-label">Select Date</label>
                        <input type="date" name="searchDate" class="form-control" value="<%= (request.getParameter("searchDate") != null) ? request.getParameter("searchDate") : new java.sql.Date(System.currentTimeMillis()) %>" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Filter History</button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-header">Results</div>
    <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th style="padding-left: 1.5rem;">ID</th>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th>Treatment</th>
                        <th>Status</th>
                        <th style="text-align: right; padding-right: 1.5rem;">Total Bill</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String searchDate = request.getParameter("searchDate");
                        if (searchDate != null) {
                            AppointmentDAO hDao = new AppointmentDAO();
                            List<Appointment> history = hDao.getAppointmentsByDate(searchDate);
                            if(history.isEmpty()) {
                    %>
                        <tr><td colspan="6" style="text-align:center; padding: 2rem; color: var(--text-muted);">No appointments found for this date.</td></tr>
                    <%
                            } else {
                                for(Appointment app : history) {
                    %>
                    <tr>
                        <td style="padding-left: 1.5rem; font-weight: 600;"><%= app.getAppointmentNumber() %></td>
                        <td style="font-weight: 500;"><%= app.getPatientName() %></td>
                        <td>Dr. <%= app.getDentistName() %></td>
                        <td style="font-size: 0.8rem; color: var(--text-muted);"><%= app.getTreatmentType() %></td>
                        <td><span class="badge <%= app.getStatus() %>"><%= app.getStatus() %></span></td>
                        <td style="text-align: right; padding-right: 1.5rem;">
                            <div style="display: flex; align-items: center; justify-content: flex-end; gap: 10px;">
                                <strong style="color: var(--primary);">LKR <%= String.format("%.2f", app.getConsultationFee() + app.getTreatmentCost()) %></strong>
                                <% if("PAID".equals(app.getStatus()) || "TREATED".equals(app.getStatus())) { %>
                                    <button onclick="viewInvoice('<%= app.getAppointmentNumber() %>')" class="btn btn-primary" style="padding: 0.3rem 0.6rem; font-size: 0.7rem;">Bill</button>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <%
                                }
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
function viewInvoice(appId) {
    window.open("billing.jsp?print=" + appId, "_blank");
}
</script>

<%@ include file="footer.jsp" %>
