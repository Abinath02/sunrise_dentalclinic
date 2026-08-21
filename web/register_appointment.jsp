<%@ page import="com.sunrisedental.dao.UserDAO, com.sunrisedental.model.User, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<style>
    /* Professional UI Styles */
    .booking-wrapper { max-width: 1100px; margin: 40px auto; padding: 0 20px; font-family: 'Inter', 'Segoe UI', Tahoma, sans-serif; }
    .booking-header { text-align: center; margin-bottom: 35px; }
    .booking-header h2 { color: #1e293b; font-weight: 700; margin-bottom: 8px; font-size: 28px; }
    .booking-header p { color: #64748b; font-size: 16px; margin: 0; }

    .alert-error { background: #fef2f2; color: #991b1b; padding: 16px; border-radius: 8px; margin-bottom: 25px; text-align: center; font-weight: 600; border: 1px solid #fecaca; display: flex; align-items: center; justify-content: center; gap: 8px; }

    .alert-success { background: #ecfdf5; color: #065f46; padding: 16px; border-radius: 8px; margin-bottom: 25px; text-align: center; font-weight: 600; border: 1px solid #a7f3d0; display: flex; align-items: center; justify-content: center; gap: 8px; }
    
    .booking-card { display: flex; flex-wrap: wrap; background: #ffffff; border-radius: 16px; box-shadow: 0 10px 40px rgba(0,0,0,0.06); overflow: hidden; border: 1px solid #f1f5f9; }
    .section-left { flex: 1.5; padding: 40px; border-right: 1px solid #f1f5f9; }
    .section-right { flex: 1; padding: 40px; background: #f8fafc; }
    
    @media (max-width: 850px) {
        .section-left, .section-right { flex: 100%; border-right: none; padding: 25px; }
    }

    .section-title { font-size: 18px; color: #0f172a; border-bottom: 2px solid #3b82f6; padding-bottom: 12px; margin-bottom: 25px; font-weight: 600; }
    
    .form-row { display: flex; gap: 20px; margin-bottom: 20px; flex-wrap: wrap; }
    .form-group { flex: 1; min-width: 220px; display: flex; flex-direction: column; }
    .form-group label { font-size: 14px; color: #475569; margin-bottom: 8px; font-weight: 600; }
    .form-control { padding: 12px 16px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px; color: #1e293b; transition: all 0.2s; background: #fff; }
    .form-control:focus { border-color: #3b82f6; outline: none; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15); }
    .form-control[readonly] { background-color: #f1f5f9; color: #64748b; cursor: not-allowed; border-color: #e2e8f0; }
    select.form-control { cursor: pointer; }
    
    .treatment-list { max-height: 380px; overflow-y: auto; padding-right: 5px; }
    .treatment-list::-webkit-scrollbar { width: 6px; }
    .treatment-list::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }
    
    .treatment-option { display: flex; align-items: center; justify-content: space-between; padding: 14px 16px; background: #fff; border: 1px solid #e2e8f0; border-radius: 10px; margin-bottom: 12px; cursor: pointer; transition: all 0.2s ease; }
    .treatment-option:hover { border-color: #3b82f6; transform: translateY(-1px); box-shadow: 0 4px 12px rgba(59, 130, 246, 0.08); }
    .treatment-name { font-size: 15px; color: #1e293b; font-weight: 500; display: flex; align-items: center; gap: 12px; }
    .treatment-name input[type="checkbox"] { width: 18px; height: 18px; accent-color: #3b82f6; cursor: pointer; }
    .treatment-price { font-size: 14px; color: #64748b; font-weight: 600; }
    
    .summary-box { margin-top: 30px; padding: 25px; background: #0f172a; color: #fff; border-radius: 12px; text-align: center; box-shadow: 0 8px 20px rgba(15, 23, 42, 0.2); }
    .summary-label { font-size: 12px; text-transform: uppercase; letter-spacing: 1.5px; color: #94a3b8; margin-bottom: 8px; display: block; font-weight: 600; }
    .summary-total { font-size: 32px; font-weight: 700; color: #10b981; }
    
    .btn-submit { width: 100%; padding: 16px; margin-top: 20px; background: #10b981; color: #fff; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background 0.2s; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2); }
    .btn-submit:hover { background: #059669; }
    .payment-badge { background: #3b82f6; color: white; padding: 4px 10px; border-radius: 6px; font-size: 12px; margin-bottom: 10px; display: inline-block; }
    .card-element { background: #fff; padding: 15px; border: 1px solid #cbd5e1; border-radius: 10px; margin-top: 10px; }
    .card-row { display: flex; gap: 10px; margin-top: 10px; }
</style>

<div class="booking-wrapper">
    <div class="booking-header">
        <h2>Premium Appointment Booking</h2>
        <p>Select your specialist, choose treatments, and get an instant cost estimate.</p>
    </div>

    <% if (request.getParameter("msg") != null) { %>
        <div class="alert-success">
            <svg width="20" height="20" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
            Appointment Registered Successfully!
        </div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
        <div class="alert-error">
            <svg width="20" height="20" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path></svg>
            <%= request.getParameter("error") %>
        </div>
    <% } %>

    <form action="AppointmentServlet" method="post" id="bookingForm" class="booking-card">
        
        <!-- Left Section: Patient Details -->
        <div class="section-left">
            <h3 class="section-title">1. Patient & Specialist Details</h3>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Appointment ID</label>
                    <input type="text" class="form-control" name="appNumber" value="APP<%= (int)(Math.random()*90000)+10000 %>" readonly>
                </div>
                <div class="form-group">
                    <label>Select Specialist</label>
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

            <div class="form-group" style="margin-bottom: 20px;">
                <label>Patient Full Name</label>
                <input type="text" class="form-control" name="patientName" value="<%= user.getFullName() %>" <%= "PATIENT".equals(user.getRole()) ? "readonly" : "" %> required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Contact Number</label>
                    <input type="tel" class="form-control" name="contact" placeholder="e.g. 077 123 4567" required>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" class="form-control" name="email" placeholder="e.g. patient@gmail.com" required>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 20px;">
                <label>Home Address</label>

            <div class="form-row">
                <div class="form-group">
                    <label>Preferred Date</label>
                    <input type="date" class="form-control" name="date" required min="<%= new java.sql.Date(System.currentTimeMillis()) %>">
                </div>
                <div class="form-group">
                    <label>Preferred Time (8:30 AM - 7:00 PM)</label>
                    <input type="time" class="form-control" name="time" required min="08:30" max="19:00">
                    <small style="color: #64748b; font-size: 11px; margin-top: 4px;">Clinic Hours: 08:30 to 19:00</small>
                </div>
            </div>
        </div>

        <!-- Right Section: Treatments -->
        <div class="section-right">
            <h3 class="section-title">2. Select Treatments</h3>
            
            <div class="treatment-list">
                <label class="treatment-option">
                    <span class="treatment-name">
                        <input type="checkbox" name="treatment" value="General Checkup" data-price="1000" onchange="calculateTotal()"> 
                        General Checkup
                    </span>
                    <span class="treatment-price">LKR 1,000</span>
                </label>
                
                <label class="treatment-option">
                    <span class="treatment-name">
                        <input type="checkbox" name="treatment" value="Teeth Cleaning" data-price="2500" onchange="calculateTotal()"> 
                        Teeth Cleaning
                    </span>
                    <span class="treatment-price">LKR 2,500</span>
                </label>
                
                <label class="treatment-option">
                    <span class="treatment-name">
                        <input type="checkbox" name="treatment" value="Deep Scaling" data-price="5000" onchange="calculateTotal()"> 
                        Deep Scaling
                    </span>
                    <span class="treatment-price">LKR 5,000</span>
                </label>

                <label class="treatment-option">
                    <span class="treatment-name">
                        <input type="checkbox" name="treatment" value="Laser Whitening" data-price="15000" onchange="calculateTotal()"> 
                        Laser Whitening
                    </span>
                    <span class="treatment-price">LKR 15,000</span>
                </label>

                <label class="treatment-option">
                    <span class="treatment-name">
                        <input type="checkbox" name="treatment" value="Root Canal" data-price="25000" onchange="calculateTotal()"> 
                        Root Canal
                    </span>
                    <span class="treatment-price">LKR 25,000</span>
                </label>

                <label class="treatment-option">
                    <span class="treatment-name">
                        <input type="checkbox" name="treatment" value="Tooth Extraction" data-price="3500" onchange="calculateTotal()"> 
                        Tooth Extraction
                    </span>
                    <span class="treatment-price">LKR 3,500</span>
                </label>

                <label class="treatment-option">
                    <span class="treatment-name">
                        <input type="checkbox" name="treatment" value="Dental Braces" data-price="60000" onchange="calculateTotal()"> 
                        Dental Braces
                    </span>
                    <span class="treatment-price">LKR 60,000</span>
                </label>
            </div>

            <div class="summary-box">
                <div class="payment-badge">Secured Consultation Fee: LKR 1,000.00</div>
                <span class="summary-label">Total Estimated Bill (Pay at Clinic)</span>
                <div class="summary-total">LKR <span id="displayTotal">0.00</span></div>
                
                <!-- Card Payment Section -->
                <div class="card-element">
                    <div class="form-group" style="text-align: left;">
                        <label style="color: #475569;">Card Number</label>
                        <input type="text" class="form-control" placeholder="**** **** **** 1234" maxlength="19">
                    </div>
                    <div class="card-row">
                        <div class="form-group" style="text-align: left;">
                            <label style="color: #475569;">Expiry</label>
                            <input type="text" class="form-control" placeholder="MM/YY">
                        </div>
                        <div class="form-group" style="text-align: left;">
                            <label style="color: #475569;">CVC</label>
                            <input type="text" class="form-control" placeholder="***">
                        </div>
                    </div>
                </div>

                <!-- Hidden inputs for backend submission -->
                <input type="hidden" name="treatmentCost" id="hiddenTotal" value="0">
                <input type="hidden" name="consultationFee" value="1000">
            </div>

            <button type="submit" class="btn-submit">Pay LKR 1,000 & Confirm Booking</button>
        </div>
    </form>
</div>

<script>
    function calculateTotal() {
        let total = 0;
        const checkboxes = document.querySelectorAll('input[name="treatment"]:checked');
        
        checkboxes.forEach((cb) => {
            total += parseFloat(cb.getAttribute('data-price'));
        });
        
        // Formats number nicely with commas (e.g., 60,000.00)
        document.getElementById('displayTotal').innerText = total.toLocaleString('en-IN', {
            minimumFractionDigits: 2, 
            maximumFractionDigits: 2
        });
        document.getElementById('hiddenTotal').value = total;
    }

    // Client-side validation for time
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

    // Show confirmation popup if success
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('msg') && urlParams.get('msg') === 'Success') {
        setTimeout(() => {
            alert("Success! Your appointment is confirmed.\n\nThe 1,000 LKR payment receipt has been sent to your email address.");
        }, 500);
    }
</script>

<%@ include file="footer.jsp" %>