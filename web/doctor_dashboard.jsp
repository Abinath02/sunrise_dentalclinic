<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<%@ include file="header.jsp" %>

<%
    AppointmentDAO dao = new AppointmentDAO();
    String doctorName = user.getFullName();
    List<Appointment> historyList = dao.getTreatmentHistoryByDoctor(doctorName);
%>

<div class="row mb-4">
    <div class="col-12">
        <div class="welcome-section">
            <h2 style="font-weight: 700; color: var(--dark);">Doctor Command Center</h2>
            <p style="color: var(--text-muted);">Manage your daily consultations and review patient history.</p>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-6">
        <div class="card h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <img src="Logo.jpg" alt="Doctor" style="width: 80px; height: 80px; border-radius: 50%; border: 3px solid var(--primary);">
                <div>
                    <h4 style="margin: 0; color: var(--dark);">Dr. <%= doctorName %></h4>
                    <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 5px;">Specialist Dentist</p>
                    <span class="badge bg-primary" style="color:white;"><%= user.getRole() %></span>
                </div>
            </div>
        </div>
    </div>
    <div class="col-6">
        <div class="card h-100" style="background: #f8fafc; border: 1px solid var(--border);">
            <div class="card-body">
                <h6 style="font-weight: 700; color: var(--dark); margin-bottom: 0.5rem;">Portal Guidance</h6>
                <ul style="list-style: none; font-size: 0.8rem; color: var(--text-muted);">
                    <li class="mb-2"><i class="fas fa-check-circle text-primary"></i> Review patients assigned specifically to you.</li>
                    <li class="mb-2"><i class="fas fa-check-circle text-primary"></i> Select treatments and add extra costs.</li>
                    <li><i class="fas fa-check-circle text-primary"></i> Finalize to send records to the cashier.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="card mt-4">
    <div class="card-header">Pending Consultations for You</div>
    <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th style="padding-left: 1.5rem; width: 15%;">Appt #</th>
                        <th style="width: 20%;">Patient Name</th>
                        <th style="width: 50%;">Treatment Selection & Extras</th>
                        <th style="text-align: right; padding-right: 1.5rem; width: 15%;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Appointment> pendingList = dao.getAppointmentsByDoctorAndStatus(doctorName, "PENDING");
                        if(pendingList.isEmpty()) {
                    %>
                        <tr><td colspan="4" style="text-align:center; padding: 3rem; color: var(--text-muted);">No pending patients assigned to you.</td></tr>
                    <% } else {
                        for(Appointment app : pendingList) {
                    %>
                    <tr>
                        <td style="padding-left: 1.5rem; vertical-align: top;">
                            <strong><%= app.getAppointmentNumber() %></strong><br>
                            <small style="color: var(--text-muted); font-size: 0.75rem;"><%= app.getAppointmentDate() %></small>
                        </td>
                        <td style="vertical-align: top; font-weight: 500;"><%= app.getPatientName() %></td>
                        <td>
                            <form action="AppointmentServlet" method="post" id="form-<%= app.getAppointmentNumber() %>">
                                <input type="hidden" name="action" value="updateTreatment">
                                <input type="hidden" name="appNumber" value="<%= app.getAppointmentNumber() %>">

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; background: #f8fafc; padding: 1rem; border-radius: 8px; border: 1px solid var(--border); margin-bottom: 1rem;">
                                    <label style="display: flex; align-items: center; gap: 8px; font-size: 0.8rem; cursor: pointer;">
                                        <input type="checkbox" name="remarks" value="Consultation" data-price="1000" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> Consultation (1000)
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-size: 0.8rem; cursor: pointer;">
                                        <input type="checkbox" name="remarks" value="Teeth Cleaning" data-price="2500" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> Cleaning (2500)
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-size: 0.8rem; cursor: pointer;">
                                        <input type="checkbox" name="remarks" value="Filling" data-price="4000" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> Filling (4000)
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-size: 0.8rem; cursor: pointer;">
                                        <input type="checkbox" name="remarks" value="Extraction" data-price="3500" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> Extraction (3500)
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-size: 0.8rem; cursor: pointer;">
                                        <input type="checkbox" name="remarks" value="Root Canal" data-price="25000" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> Root Canal (25k)
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-size: 0.8rem; cursor: pointer;">
                                        <input type="checkbox" name="remarks" value="X-Ray" data-price="2000" onchange="calculateDoctorBill('<%= app.getAppointmentNumber() %>')"> X-Ray (2000)
                                    </label>
                                </div>

                                <div style="display: flex; gap: 10px; align-items: center;">
                                    <input type="text" name="extraNotes" class="form-control" placeholder="Additional notes..." style="flex: 2;">
                                    <input type="number" id="extra-<%= app.getAppointmentNumber() %>" class="form-control" placeholder="Extra LKR" value="0" style="flex: 1; max-width: 100px;" oninput="calculateDoctorBill('<%= app.getAppointmentNumber() %>')">
                                    <div style="flex: 1.5; background: #e3f2fd; padding: 0.5rem 1rem; border-radius: 8px; border: 1px solid #bbdefb; display: flex; align-items: center;">
                                        <span style="font-weight: 700; color: var(--primary); font-size: 0.8rem; margin-right: 5px;">Total:</span>
                                        <input type="number" name="cost" id="total-<%= app.getAppointmentNumber() %>" value="0" readonly style="background: transparent; border: none; font-weight: 700; color: var(--primary); width: 100%; outline: none;">
                                    </div>
                                </div>
                            </form>
                        </td>
                        <td style="padding-right: 1.5rem; text-align: right; vertical-align: middle;">
                            <button type="submit" form="form-<%= app.getAppointmentNumber() %>" class="btn btn-primary" style="padding: 0.6rem 1rem; font-size: 0.85rem;">Finalize</button>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="card mt-4">
    <div class="card-header">Your Recent Treatment History</div>
    <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th style="padding-left: 1.5rem;">Date</th>
                        <th>Appt #</th>
                        <th>Patient</th>
                        <th>Treatments</th>
                        <th>Revenue</th>
                        <th style="text-align: right; padding-right: 1.5rem;">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if(historyList.isEmpty()) {
                    %>
                        <tr><td colspan="6" style="text-align:center; padding: 2rem; color: var(--text-muted);">No history found.</td></tr>
                    <% } else {
                        for(Appointment history : historyList) {
                    %>
                    <tr>
                        <td style="padding-left: 1.5rem; color: var(--text-muted);"><%= history.getAppointmentDate() %></td>
                        <td style="font-weight: 600;"><%= history.getAppointmentNumber() %></td>
                        <td><%= history.getPatientName() %></td>
                        <td style="font-size: 0.8rem; color: var(--text-muted);"><%= history.getTreatmentType() %></td>
                        <td style="font-weight: 700; color: var(--success);">LKR <%= String.format("%.2f", history.getTreatmentCost()) %></td>
                        <td style="text-align: right; padding-right: 1.5rem;">
                            <span class="badge <%= history.getStatus() %>"><%= history.getStatus() %></span>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
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
