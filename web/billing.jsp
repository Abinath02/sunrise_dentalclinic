<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<jsp:include page="header.jsp" />

<div class="container">
    <div class="dashboard-header">
        <h2>Pending Bills Management</h2>
        <p>Confirm payments and issue professional receipts for treated patients.</p>
    </div>

    <div class="auth-card" style="max-width: 100%;">
        <h3>Treated Patients - Waiting for Payment</h3>
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
                    <td><%= app.getPatientName() %></td>
                    <td><%= app.getDentistName() %></td>
                    <td><%= app.getTreatmentType() %></td>
                    <td><strong>LKR <%= String.format("%.2f", total) %></strong></td>
                    <td>
                        <form action="AppointmentServlet" method="post">
                            <input type="hidden" name="action" value="pay">
                            <input type="hidden" name="appNumber" value="<%= app.getAppointmentNumber() %>">
                            <button type="submit" class="btn-primary btn-sm" style="background:#27ae60;">Collect & Generate Receipt</button>
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

        printWin.document.write('<div class="qr-section"><img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=<%= java.net.URLEncoder.encode(qrData, "UTF-8") %>" /><br><small>Scan to verify patient record</small></div>');

        printWin.document.write('<div class="footer"><p>Thank you for trusting Sunrise Dental Clinic!</p><p>Get well soon!</p></div>');
        printWin.document.write('</div>');

        printWin.document.write('</body></html>');

        setTimeout(function() {
            printWin.focus();
            printWin.print();
            // printWin.close(); // Optional: close after print
        }, 1000);
    }
</script>
<% } %>

<jsp:include page="footer.jsp" />
