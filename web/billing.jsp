<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<jsp:include page="header.jsp" />

<style>
    .auth-card table { width: 100%; border-collapse: separate; border-spacing: 0; margin-top: 20px; border-radius: 12px; overflow: hidden; border: 1px solid #eef2f7; }
    .auth-card th { background: #f8fafc; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px; padding: 15px; border-bottom: 2px solid #edf2f7; text-align: left; }
    .auth-card td { padding: 15px; border-bottom: 1px solid #f1f5f9; color: #1e293b; font-size: 14px; }
    .auth-card tr:last-child td { border-bottom: none; }
    .auth-card tr:hover td { background-color: #f8fafc; }
    .btn-collect { background: #ecfdf5; color: #059669; border: 1px solid #d1fae5; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
    .btn-collect:hover { background: #d1fae5; transform: translateY(-1px); }
</style>

<div class="container">
    <div class="dashboard-header">
        <h2>Pending Bills Management</h2>
        <p>Confirm payments and issue professional receipts for treated patients.</p>
    </div>

    <div class="auth-card" style="max-width: 100%;">
        <h3>Treated Patients - Waiting for Payment</h3>

        <% if(request.getParameter("print") != null) { %>
            <div style="background: #f0fdf4; border: 1px solid #bbf7d0; padding: 15px; border-radius: 10px; margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between;">
                <span style="color: #166534; font-weight: 600;">✅ Payment Collected! If the receipt didn't pop up, click the button:</span>
                <button onclick="reprintReceipt('<%= request.getParameter("print") %>')" class="btn-collect" style="background: #22c55e; color: white; border: none;">Open Receipt</button>
            </div>
        <% } %>

        <table>
            <thead>
                <tr>
                    <th>Patient</th>
                    <th>Doctor</th>
                    <th>Treatments Given</th>
                    <th>Total Bill</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    AppointmentDAO dao = new AppointmentDAO();
                    List<Appointment> list = dao.getAppointmentsByStatus("TREATED");
                    if(list.isEmpty()) {
                %>
                    <tr><td colspan="5" style="text-align:center;">No pending bills found.</td></tr>
                <% } else {
                    for(Appointment app : list) {
                        double total = app.getConsultationFee() + app.getTreatmentCost();
                %>
                <tr>
                    <td style="font-weight: 600;"><%= app.getPatientName() %></td>
                    <td style="color: #64748b;">Dr. <%= app.getDentistName() %></td>
                    <td><small><%= app.getTreatmentType() %></small></td>
                    <td style="color: #059669; font-weight: 700;">LKR <%= String.format("%.2f", total) %></td>
                    <td>
                        <form action="AppointmentServlet" method="post">
                            <input type="hidden" name="action" value="pay">
                            <input type="hidden" name="appNumber" value="<%= app.getAppointmentNumber() %>">
                            <button type="submit" class="btn-collect">Collect & Receipt</button>
                        </form>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
    </div>
</div>

<%-- Professional PDF-Style Receipt Window --%>
<% if(request.getParameter("print") != null) {
    Appointment b = dao.getAppointment(request.getParameter("print"));
    double totalAmt = b.getConsultationFee() + b.getTreatmentCost();
    // Data for QR Code
    String qrData = "ID:" + b.getAppointmentNumber() + " | Patient:" + b.getPatientName() + " | Total:LKR" + String.format("%.2f", totalAmt) + " | Date:" + b.getAppointmentDate();
%>
<script>
    function reprintReceipt(appId) {
        window.location.href = "billing.jsp?print=" + appId;
    }

    window.onload = function() {
        var printWin = window.open('', '', 'width=900,height=800');
        printWin.document.write('<html><head><title>Sunrise Dental - Invoice #<%= b.getAppointmentNumber() %></title>');
        printWin.document.write('<style>');
        printWin.document.write('body { font-family: "Segoe UI", Tahoma, sans-serif; padding: 40px; color: #333; }');
        printWin.document.write('.invoice-box { max-width: 800px; margin: auto; padding: 30px; border: 1px solid #eee; box-shadow: 0 0 10px rgba(0, 0, 0, 0.15); font-size: 16px; line-height: 24px; }');
        printWin.document.write('.header { display: flex; justify-content: space-between; border-bottom: 2px solid #3498db; padding-bottom: 20px; margin-bottom: 20px; }');
        printWin.document.write('.header h1 { margin: 0; color: #2c3e50; }');
        printWin.document.write('.details { margin-bottom: 40px; }');
        printWin.document.write('.details table { width: 100%; border-collapse: collapse; }');
        printWin.document.write('.details td { padding: 8px 0; }');
        printWin.document.write('.item-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }');
        printWin.document.write('.item-table th { background: #f8f9fa; border-bottom: 1px solid #ddd; padding: 12px; text-align: left; }');
        printWin.document.write('.item-table td { padding: 12px; border-bottom: 1px solid #eee; }');
        printWin.document.write('.total { text-align: right; font-size: 20px; font-weight: bold; color: #2c3e50; margin-top: 20px; }');
        printWin.document.write('.footer { text-align: center; margin-top: 50px; color: #7f8c8d; font-style: italic; }');
        printWin.document.write('.qr-section { text-align: right; margin-top: 20px; }');
        printWin.document.write('</style></head><body>');

        printWin.document.write('<div class="invoice-box">');
        printWin.document.write('<div class="header"><div><h1>SUNRISE DENTAL</h1><p>Professional Oral Care</p></div><div><p><strong>Invoice #: </strong><%= b.getAppointmentNumber() %></p><p><strong>Date: </strong><%= b.getAppointmentDate() %></p></div></div>');

        printWin.document.write('<div class="details"><table><tr><td><strong>Bill To:</strong><br><%= b.getPatientName() %><br><%= b.getContactNumber() %><br><%= b.getAddress() %></td><td style="text-align:right;"><strong>Attended By:</strong><br><%= b.getDentistName() %></td></tr></table></div>');

        printWin.document.write('<table class="item-table"><thead><tr><th>Treatment Description</th><th style="text-align:right;">Amount (LKR)</th></tr></thead><tbody>');
        printWin.document.write('<tr><td><%= b.getTreatmentType() %></td><td style="text-align:right;"><%= String.format("%.2f", totalAmt) %></td></tr>');
        printWin.document.write('</tbody></table>');

        printWin.document.write('<div class="total">Grand Total: LKR <%= String.format("%.2f", totalAmt) %></div>');

        printWin.document.write('<div class="qr-section">');
        printWin.document.write('<img id="qrCode" src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=<%= java.net.URLEncoder.encode(qrData, "UTF-8") %>" alt="QR Code" />');
        printWin.document.write('<br><small>Scan to verify patient record</small></div>');

        printWin.document.write('<div class="footer"><p>Thank you for trusting Sunrise Dental Clinic!</p><p>Get well soon!</p></div>');
        printWin.document.write('</div>');

        // Escape closing script tag to prevent breaking the outer JSP script block
        printWin.document.write('<script>');
        printWin.document.write('document.getElementById("qrCode").onload = function() {');
        printWin.document.write('    window.focus();');
        printWin.document.write('    window.print();');
        printWin.document.write('};');
        printWin.document.write('setTimeout(function() { window.print(); }, 3000);');
        printWin.document.write('<\/script>');

        printWin.document.write('</body></html>');
        printWin.document.close();
    }
</script>
<% } %>

<jsp:include page="footer.jsp" />
