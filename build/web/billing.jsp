<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<jsp:include page="header.jsp" />

<div class="container">
    <div class="dashboard-header">
        <h2>Billing & Payments</h2>
        <p>Confirm payments and issue receipts for treated patients.</p>
    </div>

    <div class="auth-card" style="max-width: 100%;">
        <h3>Treated - Ready for Billing</h3>
        <table>
            <thead>
                <tr>
                    <th>Patient</th>
                    <th>Treatment</th>
                    <th>Consultation</th>
                    <th>Treatment Cost</th>
                    <th>Total</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    AppointmentDAO dao = new AppointmentDAO();
                    List<Appointment> list = dao.getAppointmentsByStatus("TREATED");
                    for(Appointment app : list) {
                        double total = app.getConsultationFee() + app.getTreatmentCost();
                %>
                <tr>
                    <td><%= app.getPatientName() %></td>
                    <td><%= app.getTreatmentType() %></td>
                    <td>$<%= app.getConsultationFee() %></td>
                    <td>$<%= app.getTreatmentCost() %></td>
                    <td><strong>$<%= total %></strong></td>
                    <td>
                        <form action="AppointmentServlet" method="post">
                            <input type="hidden" name="action" value="pay">
                            <input type="hidden" name="appNumber" value="<%= app.getAppointmentNumber() %>">
                            <button type="submit" class="btn-primary btn-sm">Collect & Print</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%-- Simple JavaScript for Auto-Printing Receipt --%>
<% if(request.getParameter("print") != null) {
    Appointment app = dao.getAppointment(request.getParameter("print"));
%>
<script>
    window.onload = function() {
        var printWin = window.open('', '', 'width=600,height=600');
        printWin.document.write('<html><body style="text-align:center;">');
        printWin.document.write('<h2>Sunrise Dental Clinic - Receipt</h2>');
        printWin.document.write('<p>Patient: <%= app.getPatientName() %></p>');
        printWin.document.write('<p>Doctor: <%= app.getDentistName() %></p>');
        printWin.document.write('<p>Treatment: <%= app.getTreatmentType() %></p>');
        printWin.document.write('<h3>Total Paid: $<%= app.getConsultationFee() + app.getTreatmentCost() %></h3>');
        printWin.document.write('</body></html>');
        printWin.print();
        printWin.close();
    }
</script>
<% } %>

<jsp:include page="footer.jsp" />
