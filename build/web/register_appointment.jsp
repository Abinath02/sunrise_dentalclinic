<%@ page import="com.sunrisedental.dao.UserDAO, com.sunrisedental.model.User, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<div class="row" style="justify-content: center;">
    <div class="col-12" style="max-width: 1000px;">
        <div class="welcome-section mb-4 text-center" style="border-left: none; border-bottom: 5px solid var(--primary);">
            <h2 style="font-weight: 700;">Premium Appointment Booking</h2>
            <p style="color: var(--text-muted);">Select your specialist, choose treatments, and get an instant cost estimate.</p>
        </div>

        <% if (request.getParameter("msg") != null) { %>
            <div style="background: #dcfce7; color: #166534; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; border: 1px solid #bbf7d0;">
                <i class="fas fa-check-circle"></i> <strong>Success!</strong> Appointment registered successfully..... We have sent your email to Bill....
            </div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div style="background: #fee2e2; color: #991b1b; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; border: 1px solid #fecaca;">
                <i class="fas fa-exclamation-triangle"></i> <%= request.getParameter("error") %>
            </div>
        <% } %>

        <form action="AppointmentServlet" method="post" id="bookingForm" class="row">
            <!-- Left Side -->
            <div class="col-7">
                <div class="card">
                    <div class="card-header">
                        <span><i class="fas fa-id-card text-primary"></i> 1. Patient & Specialist Details</span>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-6">
                                <label class="form-label">Appointment ID</label>
                                <input type="text" class="form-control" name="appNumber" value="APP<%= (int)(Math.random()*90000)+10000 %>" readonly style="background: #f1f5f9; font-weight: 700; color: var(--primary);">
                            </div>
                            <div class="col-6">
                                <label class="form-label">Select Specialist</label>
                                <select class="form-control" name="dentist" required>
                                    <option value="" disabled selected>Choose a Doctor...</option>
                                    <%
                                        UserDAO uDao = new UserDAO();
                                        List<User> doctors = uDao.getDoctors();
                                        for(User d : doctors) {
                                    %>
                                        <option value="<%= d.getFullName() %>">Dr. <%= d.getFullName() %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>

                        <div class="form-group mb-4">
                            <label class="form-label">Patient Full Name</label>
                            <input type="text" class="form-control" name="patientName" value="<%= user.getFullName() %>" <%= "PATIENT".equals(user.getRole()) ? "readonly" : "" %> required>
                        </div>

                        <div class="row mb-4">
                            <div class="col-6">
                                <label class="form-label">Contact Number</label>
                                <input type="tel" class="form-control" name="contact" placeholder="077 123 4567" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label">Email Address</label>
                                <input type="email" class="form-control" name="email" placeholder="patient@gmail.com" required>
                            </div>
                        </div>

                        <div class="form-group mb-4">
                            <label class="form-label">Home Address</label>
                            <textarea class="form-control" name="address" rows="2" placeholder="Enter your address..."></textarea>
                        </div>

                        <div class="row">
                            <div class="col-6">
                                <label class="form-label">Preferred Date</label>
                                <input type="date" class="form-control" name="date" required min="<%= new java.sql.Date(System.currentTimeMillis()) %>">
                            </div>
                            <div class="col-6">
                                <label class="form-label">Preferred Time</label>
                                <input type="time" class="form-control" name="time" required min="08:30" max="19:00">
                                <small style="display:block; margin-top:5px; color: var(--text-muted); font-size: 0.7rem;"><i class="fas fa-clock"></i> Clinic Hours: 08:30 - 19:00</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Hidden inputs for backend submission -->
                <input type="hidden" name="treatmentCost" id="hiddenTotal" value="0">
                <input type="hidden" name="consultationFee" value="1000">
            </div>

            <!-- Right Side -->
            <div class="col-5">
                <div class="card" style="border: none;">
                    <div class="card-header" style="background: var(--dark); color: var(--white);">
                        <span><i class="fas fa-tooth text-info"></i> 2. Select Treatments</span>
                    </div>
                    <div class="card-body" style="background: #f8fafc;">
                        <div style="background: white; border-radius: 8px; margin-bottom: 1.5rem; border: 1px solid var(--border);">
                            <%
                                String[][] treatments = {
                                    {"General Checkup", "1000"},
                                    {"Teeth Cleaning", "2500"},
                                    {"Deep Scaling", "5000"},
                                    {"Laser Whitening", "15000"},
                                    {"Root Canal", "25000"},
                                    {"Tooth Extraction", "3500"},
                                    {"Dental Braces", "60000"}
                                };
                                for(String[] t : treatments) {
                            %>
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 1rem; border-bottom: 1px solid #f1f5f9;">
                                <div style="display: flex; align-items: center;">
                                    <input type="checkbox" name="treatment" class="treatment-check" value="<%= t[0] %>" data-price="<%= t[1] %>" onchange="calculateTotal()" style="width: 18px; height: 18px; margin-right: 12px; cursor: pointer;">
                                    <span style="font-weight: 500; font-size: 0.9rem;"><%= t[0] %></span>
                                </div>
                                <span style="background: #f8fafc; color: var(--primary); font-weight: 700; font-size: 0.8rem; padding: 0.4rem 0.8rem; border: 1px solid var(--border); border-radius: 4px;">LKR <%= t[1] %></span>
                            </div>
                            <% } %>
                        </div>

                        <div style="background: var(--dark); color: var(--white); padding: 2rem; border-radius: 12px; text-align: center; box-shadow: var(--shadow);">
                            <div style="background: var(--primary); color: white; padding: 0.3rem 0.8rem; border-radius: 20px; font-size: 0.7rem; display: inline-block; margin-bottom: 1rem;">Secured Consultation Fee: LKR 1,000</div>
                            <p style="text-transform: uppercase; font-size: 0.7rem; opacity: 0.6; letter-spacing: 1px; margin-bottom: 0.5rem;">Total Estimate</p>
                            <h2 style="color: var(--success); font-weight: 700; margin-bottom: 1.5rem;">LKR <span id="displayTotal">0.00</span></h2>

                            <div style="background: white; border-radius: 8px; padding: 1rem; text-align: left; margin-bottom: 1.5rem;">
                                <label style="color: var(--text-muted); font-size: 0.7rem; font-weight: 700; display: block; margin-bottom: 8px;"><i class="fas fa-credit-card"></i> Card Details</label>
                                <input type="text" class="form-control" placeholder="Card Number" style="padding: 0.5rem; font-size: 0.8rem; margin-bottom: 0.5rem;">
                                <div style="display: flex; gap: 8px;">
                                    <input type="text" class="form-control" placeholder="MM/YY" style="padding: 0.5rem; font-size: 0.8rem;">
                                    <input type="text" class="form-control" placeholder="CVC" style="padding: 0.5rem; font-size: 0.8rem;">
                                </div>
                            </div>

                            <button type="submit" class="btn btn-success w-100" style="padding: 1rem; font-weight: 700;">Confirm & Pay LKR 1,000</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    function calculateTotal() {
        let total = 0;
        const checkboxes = document.querySelectorAll('.treatment-check:checked');
        checkboxes.forEach((cb) => {
            total += parseFloat(cb.getAttribute('data-price'));
        });
        document.getElementById('displayTotal').innerText = total.toLocaleString('en-US', {
            minimumFractionDigits: 2, 
            maximumFractionDigits: 2
        });
        document.getElementById('hiddenTotal').value = total;
    }

    document.getElementById('bookingForm').onsubmit = function(e) {
        const timeInput = document.getElementsByName('time')[0];
        const selectedTime = timeInput.value;
        if (selectedTime < "08:30" || selectedTime > "19:00") {
            alert("Please select a time between 8:30 AM and 7:00 PM.");
            e.preventDefault();
            return false;
        }
        return true;
    };
</script>

<%@ include file="footer.jsp" %>
