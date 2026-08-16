<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<jsp:include page="header.jsp" />

<div class="container">
    <div class="dashboard-header">
        <h2>Doctor Dashboard</h2>
        <p>Manage your patient schedule and treatment reports.</p>
    </div>

    <div class="auth-card" style="max-width: 100%;">
        <h3>Pending Consultations</h3>
        <table>
            <thead>
                <tr>
                    <th>Appt #</th>
                    <th>Patient Name</th>
                    <th>Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    AppointmentDAO dao = new AppointmentDAO();
                    List<Appointment> list = dao.getAppointmentsByStatus("PENDING");
                    for(Appointment app : list) {
                %>
                <tr>
                    <td><%= app.getAppointmentNumber() %></td>
                    <td><%= app.getPatientName() %></td>
                    <td><%= app.getAppointmentDate() %></td>
                    <td>
                        <form action="AppointmentServlet" method="post" style="display:flex; gap:10px;">
                            <input type="hidden" name="action" value="updateTreatment">
                            <input type="hidden" name="appNumber" value="<%= app.getAppointmentNumber() %>">
                            <input type="text" name="remarks" placeholder="Treatment Given" required style="flex:2;">
                            <input type="number" name="cost" placeholder="Cost" required style="width:100px;">
                            <button type="submit" class="btn-success btn-sm">Submit Report</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="footer.jsp" />
