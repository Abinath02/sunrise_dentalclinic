<%@ page import="com.sunrisedental.dao.UserDAO, com.sunrisedental.model.User, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-10">
        <div class="welcome-section shadow-sm text-center mb-4">
            <h2 class="fw-bold text-dark">Premium Appointment Booking</h2>
            <p class="text-muted">Select your specialist, choose treatments, and get an instant cost estimate.</p>
        </div>

        <% if (request.getParameter("msg") != null) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <strong>Success!</strong> Appointment registered successfully..... We have sent your email to Bill....
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <form action="AppointmentServlet" method="post" id="bookingForm" class="row g-4">
            <!-- Left Side: Details -->
            <div class="col-md-7">
                <div class="card shadow-sm h-100">
                    <div class="card-header bg-white border-bottom">
                        <h5 class="mb-0 fw-bold"><i class="fas fa-id-card me-2 text-primary"></i>1. Patient & Specialist Details</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">Appointment ID</label>
                                <input type="text" class="form-control bg-light fw-bold text-primary" name="appNumber" value="APP<%= (int)(Math.random()*90000)+10000 %>" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">Select Specialist</label>
                                <select class="form-select" name="dentist" required>
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

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-muted text-uppercase">Patient Full Name</label>
                            <input type="text" class="form-control" name="patientName" value="<%= user.getFullName() %>" <%= "PATIENT".equals(user.getRole()) ? "readonly" : "" %> required>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">Contact Number</label>
                                <input type="tel" class="form-control" name="contact" placeholder="077 123 4567" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">Email Address</label>
                                <input type="email" class="form-control" name="email" placeholder="patient@gmail.com" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-muted text-uppercase">Home Address</label>
                            <textarea class="form-control" name="address" rows="2" placeholder="Enter your address..."></textarea>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">Preferred Date</label>
                                <input type="date" class="form-control" name="date" required min="<%= new java.sql.Date(System.currentTimeMillis()) %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">Preferred Time</label>
                                <input type="time" class="form-control" name="time" required min="08:30" max="19:00">
                                <div class="form-text small"><i class="fas fa-clock me-1"></i> Clinic Hours: 08:30 - 19:00</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Side: Treatments -->
            <div class="col-md-5">
                <div class="card shadow-sm h-100 border-0 overflow-hidden">
                    <div class="card-header bg-dark text-white py-3">
                        <h5 class="mb-0 fw-bold"><i class="fas fa-tooth me-2 text-info"></i>2. Select Treatments</h5>
                    </div>
                    <div class="card-body p-4 bg-light">
                        <div class="list-group mb-4 shadow-sm rounded-3">
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
                            <label class="list-group-item d-flex justify-content-between align-items-center py-3 border-0 border-bottom">
                                <div class="form-check mb-0">
                                    <input class="form-check-input me-3 treatment-check" type="checkbox" name="treatment" value="<%= t[0] %>" data-price="<%= t[1] %>" onchange="calculateTotal()">
                                    <span class="fw-medium text-dark"><%= t[0] %></span>
                                </div>
                                <span class="badge bg-white text-primary border fw-bold px-3 py-2">LKR <%= t[1] %></span>
                            </label>
                            <% } %>
                        </div>

                        <div class="bg-dark text-white p-4 rounded-4 text-center shadow">
                            <div class="badge bg-primary mb-3 px-3 py-2">Secured Consultation Fee: LKR 1,000</div>
                            <div class="small opacity-50 text-uppercase letter-spacing-1 mb-2">Total Estimate</div>
                            <h2 class="fw-bold text-success mb-3">LKR <span id="displayTotal">0.00</span></h2>

                            <div class="bg-white rounded-3 p-3 text-start mb-4 shadow-inner">
                                <label class="small fw-bold text-muted mb-2"><i class="fas fa-credit-card me-2"></i>Card Details</label>
                                <input type="text" class="form-control form-control-sm mb-2" placeholder="Card Number">
                                <div class="row g-2">
                                    <div class="col-6"><input type="text" class="form-control form-control-sm" placeholder="MM/YY"></div>
                                    <div class="col-6"><input type="text" class="form-control form-control-sm" placeholder="CVC"></div>
                                </div>
                            </div>

                            <input type="hidden" name="treatmentCost" id="hiddenTotal" value="0">
                            <input type="hidden" name="consultationFee" value="1000">

                            <button type="submit" class="btn btn-success btn-lg w-100 py-3 fw-bold shadow">
                                Confirm & Pay LKR 1,000
                            </button>
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
