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

<div class="row mb-4">
    <div class="col-12">
        <div class="welcome-section shadow-sm">
            <h2 class="fw-bold text-dark mb-1">Admin Command Center</h2>
            <p class="text-muted mb-0">Real-time analytics and management for Sunrise Dental Clinic.</p>
        </div>
    </div>
</div>

<div class="row g-4 mb-4">
    <div class="col-md-6 col-lg-3">
        <div class="card stats-card bg-gradient-primary shadow-sm h-100">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="text-uppercase mb-2 opacity-75">Pending Today</h6>
                    <h2 class="mb-0 fw-bold"><%= pendingToday %></h2>
                </div>
                <i class="fas fa-calendar-check fa-2x opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="card stats-card bg-gradient-success shadow-sm h-100">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="text-uppercase mb-2 opacity-75">Today's Collection</h6>
                    <h2 class="mb-0 fw-bold">LKR <%= String.format("%.2f", incomeToday) %></h2>
                </div>
                <i class="fas fa-money-bill-wave fa-2x opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="card stats-card bg-gradient-info shadow-sm h-100">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="text-uppercase mb-2 opacity-75">Active Staff</h6>
                    <h2 class="mb-0 fw-bold">12</h2>
                </div>
                <i class="fas fa-user-nurse fa-2x opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="card stats-card bg-gradient-warning shadow-sm h-100">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="text-uppercase mb-2 opacity-75">Patient Satisfaction</h6>
                    <h2 class="mb-0 fw-bold">98%</h2>
                </div>
                <i class="fas fa-smile fa-2x opacity-50"></i>
            </div>
        </div>
    </div>
</div>

<div class="row g-4 mb-4">
    <div class="col-lg-8">
        <div class="card shadow-sm mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0 fw-bold text-dark">Monthly Revenue Trends</h5>
                <i class="fas fa-chart-line text-primary"></i>
            </div>
            <div class="card-body">
                <canvas id="incomeChart" height="280"></canvas>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="card shadow-sm h-100">
                    <div class="card-header">
                        <h6 class="mb-0 fw-bold">Treatment Popularity</h6>
                    </div>
                    <div class="card-body">
                        <canvas id="treatmentChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card shadow-sm h-100">
                    <div class="card-header">
                        <h6 class="mb-0 fw-bold">Patient Growth</h6>
                    </div>
                    <div class="card-body">
                        <canvas id="growthChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="card shadow-sm mb-4">
            <div class="card-header">
                <h5 class="mb-0 fw-bold text-dark">Quick Actions</h5>
            </div>
            <div class="card-body d-grid gap-2">
                <a href="register_appointment.jsp" class="btn btn-primary py-2 shadow-sm">
                    <i class="fas fa-plus-circle me-2"></i>New Appointment
                </a>
                <a href="manage_users.jsp" class="btn btn-dark py-2 shadow-sm">
                    <i class="fas fa-users-cog me-2"></i>Manage Staff
                </a>
                <a href="search_appointment.jsp" class="btn btn-outline-primary py-2 shadow-sm">
                    <i class="fas fa-search me-2"></i>Database Search
                </a>
            </div>
        </div>

        <div class="card shadow-sm bg-light border-0">
            <div class="card-body">
                <h6 class="fw-bold text-dark mb-3"><i class="fas fa-info-circle me-2 text-primary"></i>System Guidance</h6>
                <ul class="list-unstyled small text-muted mb-0">
                    <li class="mb-2 d-flex align-items-start">
                        <i class="fas fa-check-circle text-success me-2 mt-1"></i>
                        <span>Manage clinic staff and their roles from the Users section.</span>
                    </li>
                    <li class="mb-2 d-flex align-items-start">
                        <i class="fas fa-check-circle text-success me-2 mt-1"></i>
                        <span>Monitor revenue and patient growth trends in real-time.</span>
                    </li>
                    <li class="mb-2 d-flex align-items-start">
                        <i class="fas fa-check-circle text-success me-2 mt-1"></i>
                        <span>Quickly search any patient or appointment using the database search.</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="card shadow-sm mb-4">
    <div class="card-header bg-white">
        <h5 class="mb-0 fw-bold text-dark">Recent Collection History</h5>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th class="ps-4">Bill Date</th>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th class="text-end pe-4">Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Appointment> bills = statDao.getBillHistory();
                        if(bills.isEmpty()) {
                    %>
                        <tr><td colspan="4" class="text-center py-4 text-muted">No collections recorded yet.</td></tr>
                    <% } else {
                        for(int i=0; i<Math.min(bills.size(), 5); i++) {
                            Appointment b = bills.get(i);
                    %>
                    <tr>
                        <td class="ps-4 text-muted small"><%= b.getAppointmentDate() %></td>
                        <td class="fw-medium"><%= b.getPatientName() %></td>
                        <td><span class="badge bg-light text-dark fw-normal border">Dr. <%= b.getDentistName() %></span></td>
                        <td class="text-end pe-4 fw-bold text-primary">LKR <%= String.format("%.2f", b.getTreatmentCost()) %></td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
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
