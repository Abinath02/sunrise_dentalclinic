<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List" %>
<%-- 1. FIX: Added User model import --%>
<%@ page import="com.sunrisedental.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<%
    // 2. FIX: Safely retrieve the user from the session
    User loggedInUser = (User) session.getAttribute("user");
    
    // Optional: Redirect to login if user is not logged in (Security best practice)
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div class="container" style="margin-top: 30px; margin-bottom: 50px;">
    <div class="dashboard-header" style="margin-bottom: 30px;">
        <h2>My Patient Portal</h2>
        <p>Welcome back, <strong><%= loggedInUser.getFullName() %></strong>!</p>
    </div>

    <div class="row">
        <div class="col-8">
            <div class="auth-card" style="max-width: 100%; padding: 25px;">
                <h3 style="margin-bottom: 20px; border-bottom: 2px solid #f0f0f0; padding-bottom: 10px;">My Appointment History</h3>
                
                <%
                    AppointmentDAO pDao = new AppointmentDAO();
                    // Using the loggedInUser object safely
                    List<Appointment> myHistory = pDao.getAppointmentsByPatient(loggedInUser.getFullName());
                    
                    // 3. FIX: Professional empty state check. Table will only show if history exists.
                    if (myHistory != null && !myHistory.isEmpty()) {
                %>
                <table class="table" style="width: 100%; text-align: left; border-collapse: collapse;">
                    <thead>
                        <tr style="background-color: #f8f9fa; border-bottom: 2px solid #dee2e6;">
                            <th style="padding: 12px;">ID</th>
                            <th style="padding: 12px;">Doctor</th>
                            <th style="padding: 12px;">Date</th>
                            <th style="padding: 12px;">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Appointment app : myHistory) { %>
                        <tr style="border-bottom: 1px solid #eee;">
                            <td style="padding: 12px;"><%= app.getAppointmentNumber() %></td>
                            <td style="padding: 12px;"><%= app.getDentistName() %></td>
                            <td style="padding: 12px;"><%= app.getAppointmentDate() %></td>
                            <td style="padding: 12px;">
                                <%-- Dynamic badge class just like the admin page --%>
                                <span class="badge badge-<%= app.getStatus().toLowerCase() %>"><%= app.getStatus() %></span>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                    <div style="text-align: center; padding: 40px 20px; background: #f9fafb; border-radius: 8px;">
                        <p style="color: #6c757d; font-size: 1.1em; margin-bottom: 0;">You don't have any past appointments.</p>
                        <p style="color: #6c757d; font-size: 0.9em;">Book your first appointment today!</p>
                    </div>
                <% } %>
            </div>
        </div>

        <div class="col-4">
            <div class="auth-card" style="padding: 25px; margin-bottom: 20px; background: #f8fafc; border: 1px solid #cbd5e1;">
                <h4 style="color: #2c3e50; font-size: 16px; margin-bottom: 10px;">Portal Guidance</h4>
                <p style="font-size: 13px; color: #475569; margin-bottom: 8px;">1. Click Book Appointment Now to schedule a new visit with a doctor.</p>
                <p style="font-size: 13px; color: #475569; margin-bottom: 8px;">2. A 1,000 LKR booking fee is required via card to confirm your slot.</p>
                <p style="font-size: 13px; color: #475569; margin-bottom: 8px;">3. Review your past visits and payment status in the History table.</p>
                <p style="font-size: 13px; color: #475569;">4. Ensure your registered email is correct to receive digital receipts.</p>
            </div>

            <div class="auth-card" style="padding: 25px;">
                <h3 style="margin-bottom: 20px; border-bottom: 2px solid #f0f0f0; padding-bottom: 10px;">Our Specialists</h3>
                
                <%-- 4. FIX: Professional Doctor list with Photos --%>
                <div class="doctor-list" style="display: flex; flex-direction: column; gap: 15px;">
                    
                    <!-- Doctor 1 -->
                    <div class="doctor-item" style="display: flex; align-items: center; background: #f8f9fa; padding: 10px; border-radius: 8px;">
                        <img src="johny.jpg" alt="Dr. Johny" style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover; margin-right: 15px; border: 2px solid #2c3e50;">
                        <div>
                            <strong style="display: block; color: #2c3e50;">Mr. A. Johny</strong>
                            <span style="font-size: 0.85em; color: #7f8c8d;">Orthodontist</span>
                        </div>
                    </div>

                    <!-- Doctor 2 -->
                    <div class="doctor-item" style="display: flex; align-items: center; background: #f8f9fa; padding: 10px; border-radius: 8px;">
                        <img src="thulashi.jfif" alt="Dr. Thulashi" style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover; margin-right: 15px; border: 2px solid #2c3e50;">
                        <div>
                            <strong style="display: block; color: #2c3e50;">Miss. A. Thulashi</strong>
                            <span style="font-size: 0.85em; color: #7f8c8d;">General Dentist</span>
                        </div>
                    </div>

                    <!-- Doctor 3 -->
                    <div class="doctor-item" style="display: flex; align-items: center; background: #f8f9fa; padding: 10px; border-radius: 8px;">
                        <img src="ajith.png" alt="Dr. Ajith" style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover; margin-right: 15px; border: 2px solid #2c3e50;">
                        <div>
                            <strong style="display: block; color: #2c3e50;">Mr. S. Ajith</strong>
                            <span style="font-size: 0.85em; color: #7f8c8d;">Oral Surgeon</span>
                        </div>
                    </div>

                    <!-- Doctor 4 -->
                    <div class="doctor-item" style="display: flex; align-items: center; background: #f8f9fa; padding: 10px; border-radius: 8px;">
                        <img src="hitler.png" alt="Dr. Hitler" style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover; margin-right: 15px; border: 2px solid #2c3e50;">
                        <div>
                            <strong style="display: block; color: #2c3e50;">Mr. A. Hitler</strong>
                            <span style="font-size: 0.85em; color: #7f8c8d;">Periodontist</span>
                        </div>
                    </div>

                </div>
                
                <hr style="margin: 20px 0; border: 1px solid #eee;">
                <a href="register_appointment.jsp" class="btn-primary" style="display: block; text-align: center; text-decoration: none; padding: 12px; border-radius: 5px; background: #3498db; color: white; font-weight: bold; transition: background 0.3s;">Book Appointment Now</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>