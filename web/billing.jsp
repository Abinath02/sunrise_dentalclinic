<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<%@ include file="header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="welcome-section" style="border-left-color: var(--success);">
            <h2 style="font-weight: 700; color: var(--dark);">Pending Bills Management</h2>
            <p style="color: var(--text-muted);">Confirm payments and issue professional receipts for treated patients.</p>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-header">Treated Patients - Waiting for Payment</div>
    <div class="card-body" style="padding: 0;">
        <% if(request.getParameter("print") != null) { %>
            <div style="background: #f0fdf4; border: 1px solid #bbf7d0; padding: 1.5rem; margin: 1.5rem; border-radius: 12px; display: flex; align-items: center; justify-content: space-between;">
                <span style="color: #166534; font-weight: 700;"><i class="fas fa-check-circle"></i> Payment Collected! Opening receipt...</span>
                <button onclick="reprintReceipt('<%= request.getParameter("print") %>')" class="btn btn-success">Open Receipt</button>
            </div>
        <% } %>

        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th style="padding-left: 1.5rem;">Patient</th>
                        <th>Doctor</th>
                        <th>Treatments Given</th>
                        <th>Total Bill</th>
                        <th style="text-align: right; padding-right: 1.5rem;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        AppointmentDAO dao = new AppointmentDAO();
                        List<Appointment> list = dao.getAppointmentsByStatus("TREATED");
                        if(list.isEmpty()) {
                    %>
                        <tr><td colspan="5" style="text-align:center; padding: 2rem; color: var(--text-muted);">No pending bills found.</td></tr>
                    <% } else {
                        for(Appointment app : list) {
                            double total = app.getConsultationFee() + app.getTreatmentCost();
                    %>
                    <tr>
                        <td style="padding-left: 1.5rem; font-weight: 600;"><%= app.getPatientName() %></td>
                        <td style="color: var(--text-muted);">Dr. <%= app.getDentistName() %></td>
                        <td style="font-size: 0.8rem; color: var(--text-muted);"><%= app.getTreatmentType() %></td>
                        <td style="color: var(--success); font-weight: 700;">LKR <%= String.format("%.2f", total) %></td>
                        <td style="text-align: right; padding-right: 1.5rem;">
                            <form action="AppointmentServlet" method="post" style="margin: 0;">
                                <input type="hidden" name="action" value="pay">
                                <input type="hidden" name="appNumber" value="<%= app.getAppointmentNumber() %>">
                                <button type="submit" class="btn btn-success" style="padding: 0.5rem 1rem; font-size: 0.8rem;">Collect & Receipt</button>
                            </form>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- Professional PDF-Style Receipt Window --%>
<% if(request.getParameter("print") != null) {
    Appointment b = dao.getAppointment(request.getParameter("print"));
    if(b != null) {
        double totalAmt = b.getConsultationFee() + b.getTreatmentCost();
        String qrData = "ID:" + b.getAppointmentNumber() + " | Patient:" + b.getPatientName() + " | Total:LKR" + String.format("%.2f", totalAmt) + " | Date:" + b.getAppointmentDate();
%>
<script>
    function openInvoice() {
        var printWin = window.open('', '_blank', 'width=900,height=900');
        if (!printWin) {
            alert("Pop-up blocked! Please allow pop-ups to view the receipt.");
            return;
        }

        var html = `
            <html>
            <head>
                <title>Sunrise Dental - Invoice #<%= b.getAppointmentNumber() %></title>
                <style>
                    body { font-family: 'Segoe UI', Tahoma, sans-serif; padding: 40px; color: #333; }
                    .invoice-box { max-width: 800px; margin: auto; padding: 30px; border: 1px solid #eee; box-shadow: 0 0 10px rgba(0, 0, 0, 0.15); }
                    .header { display: flex; justify-content: space-between; border-bottom: 2px solid #2563eb; padding-bottom: 20px; margin-bottom: 20px; }
                    .header h1 { margin: 0; color: #0f172a; }
                    .item-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
                    .item-table th { background: #f8fafc; border-bottom: 1px solid #ddd; padding: 12px; text-align: left; }
                    .item-table td { padding: 12px; border-bottom: 1px solid #eee; }
                    .total { text-align: right; font-size: 20px; font-weight: bold; color: #0f172a; }
                    .qr-section { text-align: right; margin-top: 20px; }
                </style>
            </head>
            <body>
                <div class="invoice-box">
                    <div class="header">
                        <div><h1>SUNRISE DENTAL</h1><p>Professional Oral Care</p></div>
                        <div><p><strong>Invoice #:</strong> <%= b.getAppointmentNumber() %></p><p><strong>Date:</strong> <%= b.getAppointmentDate() %></p></div>
                    </div>
                    <div style="margin-bottom: 40px;">
                        <p><strong>Bill To:</strong> <%= b.getPatientName() %><br><%= b.getContactNumber() %><br><%= b.getAddress() %></p>
                        <p><strong>Attended By:</strong> Dr. <%= b.getDentistName() %></p>
                    </div>
                    <table class="item-table">
                        <thead><tr><th>Treatment</th><th style="text-align:right;">Amount (LKR)</th></tr></thead>
                        <tbody><tr><td><%= b.getTreatmentType() %></td><td style="text-align:right;"><%= String.format("%.2f", totalAmt) %></td></tr></tbody>
                    </table>
                    <div class="total">Grand Total: LKR <%= String.format("%.2f", totalAmt) %></div>
                    <div class="qr-section">
                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=<%= java.net.URLEncoder.encode(qrData, "UTF-8") %>" />
                        <br><small>Scan to verify patient record</small>
                    </div>
                </div>
            </body>
            </html>
        `;

        printWin.document.open();
        printWin.document.write(html);
        printWin.document.close();

        setTimeout(function() {
            printWin.focus();
            printWin.print();
        }, 1000);
    }

    function reprintReceipt(appId) {
        openInvoice();
    }

    window.onload = function() {
        openInvoice();
    };
</script>
<% } } %>

<%@ include file="footer.jsp" %>
