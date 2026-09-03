<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<%
    AppointmentDAO cDao = new AppointmentDAO();
    double incomeToday = cDao.getTodayIncome();
%>

<div class="row mb-4">
    <div class="col-12">
        <div class="welcome-section" style="border-left-color: var(--success);">
            <h2 style="font-weight: 700; color: var(--dark);">Cashier Billing Console</h2>
            <p style="color: var(--text-muted);">Today's Total Collection: <strong style="color: var(--success);">LKR <%= String.format("%.2f", incomeToday) %></strong></p>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-8">
        <div class="card">
            <div class="card-header">Collected Bills History</div>
            <div class="card-body" style="padding: 0;">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="padding-left: 1.5rem;">Bill Date</th>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th style="text-align: right; padding-right: 1.5rem;">Total Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Appointment> billHistory = cDao.getBillHistory();
                                if(billHistory.isEmpty()) {
                            %>
                                <tr><td colspan="4" style="text-align:center; padding: 2rem;">No bills collected yet.</td></tr>
                            <% } else {
                                for(Appointment bill : billHistory) {
                            %>
                            <tr>
                                <td style="padding-left: 1.5rem; color: var(--text-muted);"><%= bill.getAppointmentDate() %></td>
                                <td style="font-weight: 600;"><%= bill.getPatientName() %></td>
                                <td>Dr. <%= bill.getDentistName() %></td>
                                <td style="text-align: right; padding-right: 1.5rem; font-weight: 700; color: var(--primary);">LKR <%= String.format("%.2f", bill.getTreatmentCost()) %></td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="col-4">
        <div class="card">
            <div class="card-header">Quick Actions</div>
            <div class="card-body">
                <a href="billing.jsp" class="btn btn-primary w-100 mb-4"><i class="fas fa-money-bill-wave"></i> Pending Bills</a>
                <a href="register_appointment.jsp" class="btn btn-dark w-100"><i class="fas fa-calendar-plus"></i> Walk-in Booking</a>
            </div>
        </div>

        <div class="card" style="background: #f8fafc; border: 1px solid var(--border);">
            <div class="card-body">
                <h6 style="font-weight: 700; color: var(--dark); margin-bottom: 0.5rem;">Cashier Guidance</h6>
                <ul style="list-style: none; font-size: 0.8rem; color: var(--text-muted);">
                    <li class="mb-4"><i class="fas fa-check-circle text-success"></i> Collect payments for treated patients.</li>
                    <li class="mb-4"><i class="fas fa-check-circle text-success"></i> Issue professional receipts after payment.</li>
                    <li><i class="fas fa-check-circle text-success"></i> Manage walk-in bookings for patients at the desk.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
