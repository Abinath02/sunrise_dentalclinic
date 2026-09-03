<%@ page import="com.sunrisedental.dao.AppointmentDAO, com.sunrisedental.model.Appointment, java.util.List, java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<%
    AppointmentDAO statDao = new AppointmentDAO();
    int pendingToday = statDao.getTodayPendingCount();
    double incomeToday = statDao.getTodayIncome();

    Map<String, Double> incomeData = statDao.getMonthlyIncomeData();
    Map<String, Integer> treatmentData = statDao.getTreatmentFrequencyData();
    Map<String, Integer> growthData = statDao.getPatientGrowthData();
%>

<!-- Include Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="row mb-4">
    <div class="col-12">
        <div class="welcome-section">
            <h2 style="font-weight: 700; color: var(--dark);">Admin Command Center</h2>
            <p style="color: var(--text-muted);">Real-time analytics and management for Sunrise Dental Clinic.</p>
        </div>
    </div>
</div>

<div class="stats-grid">
    <div class="stat-card bg-primary">
        <div>
            <h6>Pending Today</h6>
            <h2><%= pendingToday %></h2>
        </div>
        <i class="fas fa-calendar-check fa-2x" style="opacity: 0.5;"></i>
    </div>
    <div class="stat-card bg-success">
        <div>
            <h6>Today's Collection</h6>
            <h2>LKR <%= String.format("%.2f", incomeToday) %></h2>
        </div>
        <i class="fas fa-money-bill-wave fa-2x" style="opacity: 0.5;"></i>
    </div>
    <div class="stat-card bg-info">
        <div>
            <h6>Active Staff</h6>
            <h2>12</h2>
        </div>
        <i class="fas fa-user-nurse fa-2x" style="opacity: 0.5;"></i>
    </div>
    <div class="stat-card bg-warning">
        <div>
            <h6>Patient Satisfaction</h6>
            <h2>98%</h2>
        </div>
        <i class="fas fa-smile fa-2x" style="opacity: 0.5;"></i>
    </div>
</div>

<div class="row">
    <div class="col-8">
        <div class="card">
            <div class="card-header">
                <span>Monthly Revenue Trends</span>
                <i class="fas fa-chart-line text-primary"></i>
            </div>
            <div class="card-body">
                <canvas id="incomeChart" height="280"></canvas>
            </div>
        </div>

        <div class="row">
            <div class="col-6">
                <div class="card">
                    <div class="card-header">Treatment Popularity</div>
                    <div class="card-body">
                        <canvas id="treatmentChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-6">
                <div class="card">
                    <div class="card-header">Patient Growth</div>
                    <div class="card-body">
                        <canvas id="growthChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">Recent Collection History</div>
            <div class="card-body" style="padding: 0;">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="padding-left: 1.5rem;">Bill Date</th>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th style="text-align: right; padding-right: 1.5rem;">Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Appointment> bills = statDao.getBillHistory();
                                if(bills.isEmpty()) {
                            %>
                                <tr><td colspan="4" style="text-align: center; padding: 2rem;">No collections recorded yet.</td></tr>
                            <% } else {
                                for(int i=0; i<Math.min(bills.size(), 5); i++) {
                                    Appointment b = bills.get(i);
                            %>
                            <tr>
                                <td style="padding-left: 1.5rem; color: var(--text-muted);"><%= b.getAppointmentDate() %></td>
                                <td style="font-weight: 500;"><%= b.getPatientName() %></td>
                                <td><span class="badge" style="background: #f1f5f9; color: var(--dark); border: 1px solid var(--border);">Dr. <%= b.getDentistName() %></span></td>
                                <td style="text-align: right; padding-right: 1.5rem; font-weight: 700; color: var(--primary);">LKR <%= String.format("%.2f", b.getTreatmentCost()) %></td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="col-4">
        <div class="card">
            <div class="card-header">Quick Actions</div>
            <div class="card-body">
                <a href="register_appointment.jsp" class="btn btn-primary w-100 mb-4"><i class="fas fa-plus-circle"></i> New Appointment</a>
                <a href="manage_users.jsp" class="btn btn-dark w-100 mb-4"><i class="fas fa-users-cog"></i> Manage Staff</a>
                <a href="search_appointment.jsp" class="btn btn-primary w-100" style="background: transparent; border: 1px solid var(--primary); color: var(--primary);"><i class="fas fa-search"></i> Database Search</a>
            </div>
        </div>

        <div class="card" style="background: #f8fafc; border: 1px solid var(--border);">
            <div class="card-body">
                <h6 style="font-weight: 700; margin-bottom: 1rem;"><i class="fas fa-info-circle text-primary"></i> System Guidance</h6>
                <ul style="list-style: none; font-size: 0.85rem; color: var(--text-muted);">
                    <li class="mb-4"><i class="fas fa-check-circle text-success"></i> Manage clinic staff and their roles from the Users section.</li>
                    <li class="mb-4"><i class="fas fa-check-circle text-success"></i> Monitor revenue and patient growth trends in real-time.</li>
                    <li><i class="fas fa-check-circle text-success"></i> Quickly search any patient or appointment.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    const ctxIncome = document.getElementById('incomeChart').getContext('2d');
    const incomeGradient = ctxIncome.createLinearGradient(0, 0, 0, 400);
    incomeGradient.addColorStop(0, 'rgba(37, 99, 235, 0.2)');
    incomeGradient.addColorStop(1, 'rgba(37, 99, 235, 0)');

    new Chart(document.getElementById('incomeChart'), {
        type: 'line',
        data: {
            labels: [<% for(String month : incomeData.keySet()) { %> "<%= month %>", <% } %>],
            datasets: [{
                label: 'Monthly Revenue (LKR)',
                data: [<% for(Double val : incomeData.values()) { %> <%= val %>, <% } %>],
                borderColor: '#2563eb',
                backgroundColor: incomeGradient,
                fill: true,
                tension: 0.4,
                pointRadius: 4,
                pointBackgroundColor: '#2563eb'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { grid: { borderDash: [5, 5] } },
                x: { grid: { display: false } }
            }
        }
    });

    new Chart(document.getElementById('treatmentChart'), {
        type: 'doughnut',
        data: {
            labels: [<% for(String type : treatmentData.keySet()) { %> "<%= type %>", <% } %>],
            datasets: [{
                data: [<% for(Integer val : treatmentData.values()) { %> <%= val %>, <% } %>],
                backgroundColor: ['#2563eb', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6'],
                borderWidth: 0
            }]
        },
        options: { plugins: { legend: { position: 'bottom' } }, cutout: '70%' }
    });

    new Chart(document.getElementById('growthChart'), {
        type: 'bar',
        data: {
            labels: [<% for(String month : growthData.keySet()) { %> "<%= month %>", <% } %>],
            datasets: [{
                label: 'New Appointments',
                data: [<% for(Integer val : growthData.values()) { %> <%= val %>, <% } %>],
                backgroundColor: '#2563eb',
                borderRadius: 5
            }]
        },
        options: {
            plugins: { legend: { display: false } },
            scales: {
                y: { grid: { borderDash: [5, 5] }, beginAtZero: true },
                x: { grid: { display: false } }
            }
        }
    });
</script>

<%@ include file="footer.jsp" %>
