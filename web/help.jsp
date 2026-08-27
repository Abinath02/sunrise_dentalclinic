<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<style>
    .help-section { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); margin-top: 20px; }
        .help-header { border-bottom: 2px solid #f1f5f9; padding-bottom: 20px; margin-bottom: 30px; }
        .help-header h2 { color: #1e293b; font-size: 28px; margin: 0; }
        .role-guide { margin-bottom: 40px; padding: 25px; border-radius: 15px; border: 1px solid #e2e8f0; transition: transform 0.2s; }
        .role-guide:hover { transform: translateY(-5px); border-color: #3b82f6; }
        .role-title { display: flex; align-items: center; gap: 12px; margin-bottom: 15px; color: #2563eb; }
        .step-list { list-style: none; padding: 0; }
        .step-list li { margin-bottom: 12px; padding-left: 30px; position: relative; color: #475569; font-size: 15px; }
        .step-list li::before { content: '→'; position: absolute; left: 0; color: #3b82f6; font-weight: bold; }
        .badge-info { background: #eff6ff; color: #1d4ed8; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; }
    </style>
<div class="help-section">
            <div class="help-header">
                <h2>Staff Training & System Guide</h2>
                <p style="color: #64748b;">Follow these step-by-step instructions to master the Sunrise Dental Management System.</p>
            </div>

            <!-- Admin Guide -->
            <div class="role-guide">
                <h3 class="role-title">👨‍💼 Administrator Portal</h3>
                <ul class="step-list">
                    <li><strong>Staff Setup:</strong> Use "Staff Management" to create accounts for new Doctors and Cashiers.</li>
                    <li><strong>Analytics:</strong> Monitor the Dashboard charts for Revenue Trends and Treatment Popularity to optimize clinic resources.</li>
                    <li><strong>Real-time Tracking:</strong> "Today's Collection" updates instantly when a patient books (1,000 LKR) and when a cashier finalizes a bill.</li>
                </ul>
            </div>

            <!-- Doctor Guide -->
            <div class="role-guide">
                <h3 class="role-title">🩺 Doctor / Specialist Portal</h3>
                <ul class="step-list">
                    <li><strong>Check Queue:</strong> Your dashboard only shows patients assigned to <strong>you</strong>. Check "Pending Consultations" every morning.</li>
                    <li><strong>Consultation:</strong> Click the checkboxes for treatments provided (Cleaning, Extraction, etc.).</li>
                    <li><strong>Finalize:</strong> Enter additional notes and any extra costs, then click "Finalize & Bill" to send the record to the Cashier.</li>
                    <li><strong>History:</strong> Review "Lifetime Treatments" to track your personal performance and revenue contribution.</li>
                </ul>
            </div>

            <!-- Cashier Guide -->
            <div class="role-guide">
                <h3 class="role-title">💰 Cashier / Reception Portal</h3>
                <ul class="step-list">
                    <li><strong>Payment Collection:</strong> Go to "Billing". You will see patients finalized by doctors.</li>
                    <li><strong>Verify:</strong> Check the "Treatments Given" and "Total Bill" columns.</li>
                    <li><strong>Receipt:</strong> Click "Collect & Receipt". A professional invoice with a QR code will pop up automatically.</li>
                    <li><strong>Troubleshoot:</strong> If the popup is blocked, a green "Open Receipt" button will appear to manually trigger the print window.</li>
                </ul>
            </div>

            <!-- General Security -->
            <div class="role-guide" style="background: #fffbeb; border-color: #fde68a;">
                <h3 class="role-title" style="color: #92400e;">⚠️ Security & Best Practices</h3>
                <ul class="step-list">
                    <li>Always <strong>Logout</strong> before leaving your workstation.</li>
                    <li>Ensure the patient's <strong>Email Address</strong> is correct during booking to ensure they receive their digital receipts.</li>
                    <li>The system uses <strong>JNDI Pooling</strong>; if you see a connection error, notify the IT Admin immediately.</li>
                </ul>
            </div>
        </div>

    <%@ include file="footer.jsp" %>
