<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<%
    AppointmentDAO cDao = new AppointmentDAO();
    double incomeToday = cDao.getTodayIncome();
%>

<div class="container">
    <div class="dashboard-header">
        <h2>Cashier Billing Console</h2>
        <p>Manage daily sales: <strong>Today's Collection: LKR <%= String.format("%.2f", incomeToday) %></strong></p>
    </div>

    <div class="row">
        <div class="col-8">
            <div class="auth-card" style="max-width: 100%;">
                <h3>Collected Bills History</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Bill Date</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Total Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Appointment> billHistory = cDao.getBillHistory();
                            if(billHistory.isEmpty()) {
                        %>
                            <tr><td colspan="4" style="text-align:center;">No bills collected yet.</td></tr>
                        <% } else {
                            for(Appointment bill : billHistory) {
                        %>
                        <tr>
                            <td><%= bill.getAppointmentDate() %></td>
                            <td><%= bill.getPatientName() %></td>
                            <td><%= bill.getDentistName() %></td>
                            <td><strong>LKR <%= String.format("%.2f", bill.getTreatmentCost()) %></strong></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-4">
            <div class="auth-card">
                <h3>Quick Actions</h3>
                <a href="billing.jsp" class="btn-primary" style="display:block; text-align:center; margin-bottom:15px; text-decoration:none;">Process New Bill</a>
                <a href="register_appointment.jsp" class="btn-primary" style="display:block; text-align:center; margin-bottom:15px; text-decoration:none; background:#344950;">Walk-in Booking</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
