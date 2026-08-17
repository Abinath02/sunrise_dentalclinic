<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<div class="container">
    <div class="dashboard-header">
        <h2>Appointment History</h2>
        <p>Filter and view patient appointments by date.</p>
    </div>

    <div class="auth-card" style="max-width: 400px; margin: 0 auto 30px auto;">
        <form action="appointment_history.jsp" method="get">
            <div class="form-group">
                <label>Select Date</label>
                <input type="date" name="searchDate" value="<%= (request.getParameter("searchDate") != null) ? request.getParameter("searchDate") : new java.sql.Date(System.currentTimeMillis()) %>" required>
            </div>
            <button type="submit" class="btn-primary" style="width:100%;">Filter History</button>
        </form>
    </div>

    <div class="auth-card" style="max-width: 100%;">
        <h3>Results</h3>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Patient</th>
                    <th>Doctor</th>
                    <th>Treatment</th>
                    <th>Status</th>
                    <th>Total Bill</th>
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
                    <tr><td colspan="6" style="text-align:center;">No appointments found for this date.</td></tr>
                <%
                        } else {
                            for(Appointment app : history) {
                %>
                <tr>
                    <td><%= app.getAppointmentNumber() %></td>
                    <td><%= app.getPatientName() %></td>
                    <td><%= app.getDentistName() %></td>
                    <td><%= app.getTreatmentType() %></td>
                    <td><span class="badge <%= app.getStatus() %>"><%= app.getStatus() %></span></td>
                    <td>LKR <%= String.format("%.2f", app.getConsultationFee() + app.getTreatmentCost()) %></td>
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

<%@ include file="footer.jsp" %>
