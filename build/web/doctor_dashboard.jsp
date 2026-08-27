<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<%@ include file="header.jsp" %>

<style>
    /* Enhanced UI Styles */
    .dashboard-grid { display: grid; grid-template-columns: 1fr 2fr; gap: 20px; margin-bottom: 30px; }
    .profile-card { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
    .profile-img { width: 80px; height: 80px; border-radius: 50%; border: 3px solid #3498db; margin-bottom: 15px; }
    .profile-details h4 { margin: 5px 0; color: #2c3e50; }
    .profile-details p { color: #7f8c8d; font-size: 14px; margin: 0; }

    .stats-container { display: flex; gap: 15px; }
    .stat-box { flex: 1; padding: 20px; border-radius: 12px; text-align: center; color: white; }
    .stat-pending { background: #f39c12; }
    .stat-completed { background: #27ae60; }
    .stat-box h2 { margin: 10px 0 0 0; font-size: 32px; }

    .treatment-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; background: #f8f9fa; padding: 15px; border-radius: 8px; border: 1px solid #e0e0e0; }
    .treatment-label { display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 14px; }
    .billing-section { margin-top: 15px; display: flex; gap: 15px; align-items: center; }
    .billing-input { padding: 10px; border-radius: 8px; border: 1px solid #ddd; font-size: 14px; }
    .notes-input { flex: 2; }
    .extra-input { flex: 1; max-width: 120px; }
    .total-box { display: flex; align-items: center; background: #e3f2fd; border: 1px solid #bbdefb; padding: 8px 15px; border-radius: 8px; flex: 1; min-width: 180px; }
    .total-box span { font-weight: bold; color: #1565c0; margin-right: 10px; }
    .total-box input { border: none; background: transparent; font-size: 18px; font-weight: bold; color: #0d47a1; width: 100%; outline: none; }
    .btn-finalize { background: #3498db; color: white; border: none; padding: 12px; border-radius: 8px; cursor: pointer; width: 100%; font-weight: bold; transition: 0.3s; }
    .btn-finalize:hover { background: #2980b9; }

    .history-card { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-top: 30px; }
    .status-badge { padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; text-transform: uppercase; }
    .status-treated { background: #e8f5e9; color: #2e7d32; }
    .status-paid { background: #e3f2fd; color: #1565c0; }
</style>

<%
    AppointmentDAO dao = new AppointmentDAO();
    String doctorName = user.getFullName();
    int pendingToday = dao.getTodayPendingCountByDoctor(doctorName);
    List<Appointment> historyList = dao.getTreatmentHistoryByDoctor(doctorName);
%>

<div class="dashboard-header">
        <h2>Doctor Command Center</h2>
        <p>Manage your daily consultations and review patient history.</p>
    </div>

    <!-- Top Row: Profile & Stats -->
    <div class="dashboard-grid">
        <div class="profile-card">
            <div style="display: flex; align-items: center; gap: 20px;">
                <img src="Logo.jpg" alt="Doctor" class="profile-img">
                <div class="profile-details">
                    <h4>Dr. <%= doctorName %></h4>
                    <p>Role: <%= user.getRole() %></p>
                    <p>Username: @<%= user.getUsername() %></p>
                    <p style="margin-top: 10px; font-weight: 600; color: #3498db;">Specialist Dentist</p>
                </div>
            </div>
        </div>

        <div class="profile-card">
            <h4 style="color: #2c3e50; font-size: 16px; margin-bottom: 10px;">Portal Guidance</h4>
            <p style="font-size: 13px; color: #475569; margin-bottom: 5px;">1. The Pending Consultations table shows patients specifically assigned to you.</p>
            <p style="font-size: 13px; color: #475569; margin-bottom: 5px;">2. Select the treatments provided and add extra notes or costs if necessary.</p>
            <p style="font-size: 13px; color: #475569; margin-bottom: 5px;">3. Click Finalize and Bill to send the record to the cashier for payment collection.</p>
            <p style="font-size: 13px; color: #475569;">4. Review your lifetime treatment count and history in the bottom section.</p>
        </div>
    </div>

    <!-- Middle Section: Pending Consultations -->
    <div class="auth-card" style="max-width: 100%;">
        <h3>Pending Consultations for You</h3>
        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr style="text-align: left; border-bottom: 2px solid #eee;">
                    <th style="padding: 10px; width: 15%;">Appt #</th>
                    <th style="padding: 10px; width: 20%;">Patient Name</th>
                    <th style="padding: 10px; width: 50%;">Treatment Selection & Extras</th>
                    <th style="padding: 10px; width: 15%;">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Appointment> pendingList = dao.getAppointmentsByDoctorAndStatus(doctorName, "PENDING");
                    if(pendingList.isEmpty()) {
                %>
                    <tr><td colspan="4" style="text-align:center; padding: 20px;">Great job! No pending patients assigned to you.</td></tr>
                <% } else {
                    for(Appointment app : pendingList) {
                %>
                <tr style="border-bottom: 1px solid #eee;">
                    <td style="padding: 15px 10px; vertical-align: top;">
                        <strong><%= app.getAppointmentNumber() %></strong><br>
                        <small style="color: #777;"><%= app.getAppointmentDate() %> at <%= app.getAppointmentTime() %></small>
                    </td>
                    <td style="padding: 15px 10px; vertical-align: top;"><%= app.getPatientName() %></td>
                    <td style="padding: 15px 10px;">
                        <form action="AppointmentServlet" method="post" id="form-<%= app.getAppointmentNumber() %>">
                            <input type="hidden" name="action" value="updateTreatment">
                            <input type="hidden" name="appNumber" value="<%= app.getAppointmentNumber() %>">

                            <div class="treatment-grid">
                                <label class="treatment-label">
                                    <input type="checkbox" name="remarks" value="Consultation" data-price="1000" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> Consultation (1000)
                                </label>
                                <label class="treatment-label">
                                    <input type="checkbox" name="remarks" value="Teeth Cleaning" data-price="2500" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> Cleaning (2500)
                                </label>
                                <label class="treatment-label">
                                    <input type="checkbox" name="remarks" value="Filling" data-price="4000" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> Filling (4000)
                                </label>
                                <label class="treatment-label">
                                    <input type="checkbox" name="remarks" value="Extraction" data-price="3500" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> Extraction (3500)
                                </label>
                                <label class="treatment-label">
                                    <input type="checkbox" name="remarks" value="Root Canal" data-price="25000" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> Root Canal (25k)
                                </label>
                                <label class="treatment-label">
                                    <input type="checkbox" name="remarks" value="X-Ray" data-price="2000" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> X-Ray (2000)
                                </label>
                            </div>

                            <div class="billing-section">
                                <input type="text" name="extraNotes" class="billing-input notes-input" placeholder="Additional notes...">
                                <input type="number" id="extra-<%= app.getAppointmentNumber() %>" class="billing-input extra-input" placeholder="Extra LKR" value="0" oninput="calculateDoctorBill('<%= app.getAppointmentNumber() %>')">
                                <div class="total-box">
                                    <span>Total: Rs.</span>
                                    <input type="number" name="cost" id="total-<%= app.getAppointmentNumber() %>" value="0" readonly>
                                </div>
                            </div>
                        </form>
                    </td>
                    <td style="padding: 15px 10px; vertical-align: bottom;">
                        <button type="submit" form="form-<%= app.getAppointmentNumber() %>" class="btn-finalize">Finalize & Bill</button>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
    </div>

    <!-- Bottom Section: Treatment History -->
    <div class="history-card">
        <h3>Your Recent Treatment History</h3>
        <table style="width: 100%; border-collapse: collapse; margin-top: 15px;">
            <thead>
                <tr style="text-align: left; border-bottom: 2px solid #eee;">
                    <th style="padding: 12px;">Date</th>
                    <th style="padding: 12px;">Appt #</th>
                    <th style="padding: 12px;">Patient</th>
                    <th style="padding: 12px;">Treatments Provided</th>
                    <th style="padding: 12px;">Revenue (LKR)</th>
                    <th style="padding: 12px;">Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if(historyList.isEmpty()) {
                %>
                    <tr><td colspan="6" style="text-align:center; padding: 20px; color: #7f8c8d;">No history found.</td></tr>
                <% } else {
                    for(Appointment history : historyList) {
                %>
                <tr style="border-bottom: 1px solid #f8f9fa;">
                    <td style="padding: 12px;"><%= history.getAppointmentDate() %></td>
                    <td style="padding: 12px;"><strong><%= history.getAppointmentNumber() %></strong></td>
                    <td style="padding: 12px;"><%= history.getPatientName() %></td>
                    <td style="padding: 12px;"><%= history.getTreatmentType() %></td>
                    <td style="padding: 12px; font-weight: 600;"><%= String.format("%.2f", history.getTreatmentCost()) %></td>
                    <td style="padding: 12px;">
                        <span class="status-badge <%= "PAID".equals(history.getStatus()) ? "status-paid" : "status-treated" %>">
                            <%= history.getStatus() %>
                        </span>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
    </div>

<script>
    function calculateDoctorBill(appId) {
        let total = 0;
        const form = document.getElementById('form-' + appId);
        const checkboxes = form.querySelectorAll('input[name="remarks"]:checked');
        const extraInput = document.getElementById('extra-' + appId).value;
        const extra = extraInput === "" ? 0 : parseFloat(extraInput);

        checkboxes.forEach((cb) => {
            total += parseFloat(cb.getAttribute('data-price'));
        });

        document.getElementById('total-' + appId).value = total + extra;
    }
</script>

<%@ include file="footer.jsp" %>