<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List, java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<%
    AppointmentDAO statDao = new AppointmentDAO();
    int pendingToday = statDao.getTodayPendingCount();
    double incomeToday = statDao.getTodayIncome();

    // Fetch Data for Charts
    Map<String, Double> incomeData = statDao.getMonthlyIncomeData();
    Map<String, Integer> treatmentData = statDao.getTreatmentFrequencyData();
    Map<String, Integer> growthData = statDao.getPatientGrowthData();
%>

<!-- Include Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
    .chart-container { background: white; padding: 20px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 25px; }
    .chart-title { font-size: 18px; font-weight: 600; color: #2c3e50; margin-bottom: 15px; border-bottom: 2px solid #f8fafc; padding-bottom: 10px; }
</style>

<div class="container">
    <div class="dashboard-header">
        <h2>Admin Command Center</h2>
        <p>Real-time analytics and management for Sunrise Dental Clinic.</p>
    </div>

    <div class="row">
        <!-- Left Column (Stats & Charts) -->
        <div class="col-8">
            <!-- Summary Stats -->
            <div class="auth-card" style="max-width: 100%; margin-bottom: 25px;">
                <h3 class="chart-title">Today's Performance</h3>
                <div style="display: flex; gap: 20px;">
                    <div style="flex: 1; background: #e3f2fd; padding: 25px; border-radius: 15px; text-align: center; border-bottom: 5px solid #2196f3;">
                        <h4 style="margin:0; color:#1976d2;">Pending Today</h4>
                        <p style="font-size: 36px; font-weight: bold; margin:10px 0;"><%= pendingToday %></p>
                    </div>
                    <div style="flex: 1; background: #e8f5e9; padding: 25px; border-radius: 15px; text-align: center; border-bottom: 5px solid #4caf50;">
                        <h4 style="margin:0; color:#388e3c;">Today's Collection</h4>
                        <p style="font-size: 36px; font-weight: bold; margin:10px 0;">LKR <%= String.format("%.2f", incomeToday) %></p>
                    </div>
                </div>
            </div>

            <!-- Income Trend Chart -->
            <div class="chart-container">
                <h3 class="chart-title">Monthly Income Trends (LKR)</h3>
                <canvas id="incomeChart" height="100"></canvas>
            </div>

            <div class="row">
                <div class="col-6">
                    <div class="chart-container">
                        <h3 class="chart-title">Treatment Popularity</h3>
                        <canvas id="treatmentChart"></canvas>
                    </div>
                </div>
                <div class="col-6">
                    <div class="chart-container">
                        <h3 class="chart-title">Patient Growth</h3>
                        <canvas id="growthChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="auth-card" style="max-width: 100%;">
                <h3 class="chart-title">Recent Collection History</h3>
                <table style="width: 100%;">
                    <thead>
                        <tr>
                            <th>Bill Date</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Appointment> bills = statDao.getBillHistory();
                            if(bills.isEmpty()) {
                        %>
                            <tr><td colspan="4" style="text-align:center;">No collections recorded.</td></tr>
                        <% } else {
                            for(int i=0; i<Math.min(bills.size(), 5); i++) {
                                Appointment b = bills.get(i);
                        %>
                        <tr>
                            <td><%= b.getAppointmentDate() %></td>
                            <td><%= b.getPatientName() %></td>
                            <td><%= b.getDentistName() %></td>
                            <td><strong>LKR <%= String.format("%.2f", b.getTreatmentCost()) %></strong></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Right Column (Sidebar) -->
        <div class="col-4">
            <div class="auth-card">
                <h3>System Management</h3>
                <a href="register_appointment.jsp" class="btn-primary" style="display:block; text-align:center; margin-bottom:15px; text-decoration:none;">Add Appointment</a>
                <a href="manage_users.jsp" class="btn-primary" style="display:block; text-align:center; margin-bottom:15px; text-decoration:none; background:#34495e;">Manage Staff</a>
                <a href="search_appointment.jsp" class="btn-primary" style="display:block; text-align:center; margin-bottom:15px; text-decoration:none; background:#344950;">Database Search</a>
            </div>

            <div class="auth-card" style="margin-top: 20px; background: #f8fafc; border: 1px dashed #cbd5e1;">
                <h4 style="color: #64748b; font-size: 14px;">Quick Tip</h4>
                <p style="font-size: 13px; color: #94a3b8;">Use the charts to identify peak hours and popular services to optimize staff scheduling.</p>
            </div>
        </div>
    </div>
</div>

<script>
    // Data Preparation from JSP
    const incomeLabels = [<% for(String month : incomeData.keySet()) { %> "<%= month %>", <% } %>];
    const incomeValues = [<% for(Double val : incomeData.values()) { %> <%= val %>, <% } %>];

    const treatLabels = [<% for(String type : treatmentData.keySet()) { %> "<%= type %>", <% } %>];
    const treatValues = [<% for(Integer val : treatmentData.values()) { %> <%= val %>, <% } %>];

    const growthLabels = [<% for(String month : growthData.keySet()) { %> "<%= month %>", <% } %>];
    const growthValues = [<% for(Integer val : growthData.values()) { %> <%= val %>, <% } %>];

    // Income Chart (Line)
    new Chart(document.getElementById('incomeChart'), {
        type: 'line',
        data: {
            labels: incomeLabels,
            datasets: [{
                label: 'Monthly Revenue',
                data: incomeValues,
                borderColor: '#2563eb',
                backgroundColor: 'rgba(37, 99, 235, 0.1)',
                fill: true,
                tension: 0.4
            }]
        },
        options: { responsive: true }
    });

    // Treatment Chart (Doughnut)
    new Chart(document.getElementById('treatmentChart'), {
        type: 'doughnut',
        data: {
            labels: treatLabels,
            datasets: [{
                data: treatValues,
                backgroundColor: ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6']
            }]
        }
    });

    // Growth Chart (Bar)
    new Chart(document.getElementById('growthChart'), {
        type: 'bar',
        data: {
            labels: growthLabels,
            datasets: [{
                label: 'New Appointments',
                data: growthValues,
                backgroundColor: '#10b981'
            }]
        },
        options: { scales: { y: { beginAtZero: true } } }
    });
</script>

<%@ include file="footer.jsp" %>
