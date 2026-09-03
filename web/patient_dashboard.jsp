<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List, com.sunrisedental.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div class="row mb-4">
    <div class="col-12">
        <div class="welcome-section">
            <h2 style="font-weight: 700; color: var(--dark);">My Patient Portal</h2>
            <p style="color: var(--text-muted);">Welcome back, <strong><%= loggedInUser.getFullName() %></strong>!</p>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-8">
        <div class="card">
            <div class="card-header">My Appointment History</div>
            <div class="card-body" style="padding: 0;">
                <%
                    AppointmentDAO pDao = new AppointmentDAO();
                    List<Appointment> myHistory = pDao.getAppointmentsByPatient(loggedInUser.getFullName());
                    if (myHistory != null && !myHistory.isEmpty()) {
                %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="padding-left: 1.5rem;">ID</th>
                                <th>Doctor</th>
                                <th>Date</th>
                                <th style="text-align: right; padding-right: 1.5rem;">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Appointment app : myHistory) { %>
                            <tr>
                                <td style="padding-left: 1.5rem; font-weight: 600;"><%= app.getAppointmentNumber() %></td>
                                <td>Dr. <%= app.getDentistName() %></td>
                                <td style="color: var(--text-muted);"><%= app.getAppointmentDate() %></td>
                                <td style="text-align: right; padding-right: 1.5rem;">
                                    <span class="badge <%= app.getStatus() %>"><%= app.getStatus() %></span>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                    <div style="text-align: center; padding: 3rem;">
                        <p style="color: var(--text-muted); font-size: 1.1rem; margin-bottom: 0.5rem;">You don't have any past appointments.</p>
                        <a href="register_appointment.jsp" style="color: var(--primary); font-weight: 600; text-decoration: none;">Book your first appointment today!</a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <div class="col-4">
        <div class="card mb-4" style="background: #f8fafc; border: 1px solid var(--border);">
            <div class="card-body">
                <h6 style="font-weight: 700; color: var(--dark); margin-bottom: 0.5rem;">Portal Guidance</h6>
                <ul style="list-style: none; font-size: 0.8rem; color: var(--text-muted);">
                    <li class="mb-4"><i class="fas fa-check-circle text-primary"></i> Book new appointments anytime.</li>
                    <li class="mb-4"><i class="fas fa-check-circle text-primary"></i> 1,000 LKR fee for each booking.</li>
                    <li><i class="fas fa-check-circle text-primary"></i> Track your dental health history.</li>
                </ul>
            </div>
        </div>

        <div class="card">
            <div class="card-header">Our Specialists</div>
            <div class="card-body">
                <div style="display: flex; flex-direction: column; gap: 1rem;">
                    <%
                        String[][] specs = {
                            {"Mr. A. Johny", "Orthodontist", "johny.jpg"},
                            {"Miss. A. Thulashi", "General Dentist", "thulashi.jfif"},
                            {"Mr. S. Ajith", "Oral Surgeon", "ajith.png"},
                            {"Mr. A. Hitler", "Periodontist", "hitler.png"}
                        };
                        for(String[] s : specs) {
                    %>
                    <div style="display: flex; align-items: center; background: #f8fafc; padding: 0.75rem; border-radius: 8px; border: 1px solid var(--border);">
                        <img src="<%= s[2] %>" alt="<%= s[0] %>" style="width: 45px; height: 45px; border-radius: 50%; object-fit: cover; margin-right: 12px; border: 1px solid var(--dark);">
                        <div>
                            <strong style="display: block; color: var(--dark); font-size: 0.85rem;"><%= s[0] %></strong>
                            <span style="font-size: 0.75rem; color: var(--text-muted);"><%= s[1] %></span>
                        </div>
                    </div>
                    <% } %>
                </div>
                <div style="margin-top: 1.5rem;">
                    <a href="register_appointment.jsp" class="btn btn-primary w-100">Book Appointment Now</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
