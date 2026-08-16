<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<%
    AppointmentDAO statDao = new AppointmentDAO();
    int pendingToday = statDao.getTodayPendingCount();
    double incomeToday = statDao.getTodayIncome();
%>

<div class="container">
    <div class="dashboard-header">
        <h2>Admin Command Center</h2>
        <p>Real-time analytics and management for Sunrise Dental Clinic.</p>
    </div>

    <div class="row">
        <div class="col-8">
            <div class="auth-card" style="max-width: 100%;">
                <h3>Today's Performance</h3>
                <div style="display: flex; gap: 20px;">
                    <div style="flex: 1; background: #e3f2fd; padding: 25px; border-radius: 15px; text-align: center; border-bottom: 5px solid #2196f3;">
                        <h4 style="margin:0; color:#1976d2;">Pending Today</h4>
                        <p style="font-size: 36px; font-weight: bold; margin:10px 0;"><%= pendingToday %></p>
                    </div>
                    <div style="flex: 1; background: #e8f5e9; padding: 25px; border-radius: 15px; text-align: center; border-bottom: 5px solid #4caf50;">
                        <h4 style="margin:0; color:#388e3c;">Today's Collection</h4>
                        <p style="font-size: 36px; font-weight: bold; margin:10px 0;">LKR <%= String.format("%.2f", incomeToday) %></p>
                    </div>
                </div>
            </div>

            <div class="auth-card" style="max-width: 100%;">
                <h3>Recent Collection History</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Bill Date</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Appointment> bills = statDao.getBillHistory();
                            if(bills.isEmpty()) {
                        %>
                            <tr><td colspan="4" style="text-align:center;">No collections recorded.</td></tr>
                        <% } else {
                            for(int i=0; i<Math.min(bills.size(), 5); i++) {
                                Appointment b = bills.get(i);
                        %>
                        <tr>
                            <td><%= b.getAppointmentDate() %></td>
                            <td><%= b.getPatientName() %></td>
                            <td><%= b.getDentistName() %></td>
                            <td><strong>LKR <%= String.format("%.2f", b.getTreatmentCost()) %></strong></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-4">
            <div class="auth-card">
                <h3>System Management</h3>
                <a href="register_appointment.jsp" class="btn-primary" style="display:block; text-align:center; margin-bottom:15px; text-decoration:none;">Add Appointment</a>
                <a href="manage_users.jsp" class="btn-primary" style="display:block; text-align:center; margin-bottom:15px; text-decoration:none; background:#34495e;">Manage Staff</a>
                <a href="search_appointment.jsp" class="btn-primary" style="display:block; text-align:center; margin-bottom:15px; text-decoration:none; background:#344950;">Database Search</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
