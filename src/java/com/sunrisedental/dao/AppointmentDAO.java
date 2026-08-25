package com.sunrisedental.dao;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    
    public boolean registerAppointment(Appointment app) {
        String query = "INSERT INTO appointments (appointment_number, patient_name, address, contact_number, email, dentist_name, treatment_type, appointment_date, appointment_time, consultation_fee, treatment_cost, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, app.getAppointmentNumber());
            ps.setString(2, app.getPatientName());
            ps.setString(3, app.getAddress());
            ps.setString(4, app.getContactNumber());
            ps.setString(5, app.getEmail());
            ps.setString(6, app.getDentistName());
            ps.setString(7, app.getTreatmentType());
            ps.setDate(8, app.getAppointmentDate());
            ps.setTime(9, app.getAppointmentTime());
            ps.setDouble(10, app.getConsultationFee());
            ps.setDouble(11, app.getTreatmentCost());
            
            boolean success = ps.executeUpdate() > 0;
            
            if (success) {
                // Track the 1000 LKR Consultation Fee as immediate income
                String billQuery = "INSERT INTO bills (appointment_number, patient_name, total_amount) VALUES (?, ?, ?)";
                try (PreparedStatement psBill = conn.prepareStatement(billQuery)) {
                    psBill.setString(1, app.getAppointmentNumber());
                    psBill.setString(2, app.getPatientName());
                    psBill.setDouble(3, app.getConsultationFee());
                    psBill.executeUpdate();
                }
            }
            
            return success;
        } catch (SQLException e) {
            System.err.println("Error registering appointment: " + e.getMessage());
        }
        return false;
    }

    public Appointment getAppointment(String appNumber) {
        String query = "SELECT * FROM appointments WHERE appointment_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, appNumber);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Appointment app = new Appointment();
                app.setAppointmentNumber(rs.getString("appointment_number"));
                app.setPatientName(rs.getString("patient_name"));
                app.setAddress(rs.getString("address"));
                app.setContactNumber(rs.getString("contact_number"));
                app.setEmail(rs.getString("email"));
                app.setDentistName(rs.getString("dentist_name"));
                app.setTreatmentType(rs.getString("treatment_type"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setAppointmentTime(rs.getTime("appointment_time"));
                app.setConsultationFee(rs.getDouble("consultation_fee"));
                app.setTreatmentCost(rs.getDouble("treatment_cost"));
                app.setStatus(rs.getString("status"));
                return app;
            }
        } catch (SQLException e) {
            System.err.println("Error fetching appointment: " + e.getMessage());
        }
        return null;
    }

    public List<Appointment> getAppointmentsByPatient(String patientName) {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE patient_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, patientName);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setAppointmentNumber(rs.getString("appointment_number"));
                app.setDentistName(rs.getString("dentist_name"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setAppointmentTime(rs.getTime("appointment_time"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateTreatment(String appNumber, String remarks, double cost) {
        String query = "UPDATE appointments SET treatment_type = ?, treatment_cost = ?, status = 'TREATED' WHERE appointment_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, remarks);
            ps.setDouble(2, cost);
            ps.setString(3, appNumber);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean markAsPaid(String appNumber) {
        // Step 1: Get appointment details first
        Appointment app = getAppointment(appNumber);
        if (app == null) return false;

        double total = app.getTreatmentCost(); // Only bill the treatment cost part, as 1000 was already billed at booking

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Transaction start

            // 1. Update appointment status
            String updateQuery = "UPDATE appointments SET status = 'PAID' WHERE appointment_number = ?";
            PreparedStatement psUpdate = conn.prepareStatement(updateQuery);
            psUpdate.setString(1, appNumber);
            psUpdate.executeUpdate();

            // 2. Insert into bills table (Remaining amount)
            if (total > 0) {
                String insertBillQuery = "INSERT INTO bills (appointment_number, patient_name, total_amount) VALUES (?, ?, ?)";
                PreparedStatement psBill = conn.prepareStatement(insertBillQuery);
                psBill.setString(1, appNumber);
                psBill.setString(2, app.getPatientName());
                psBill.setDouble(3, total);
                psBill.executeUpdate();
            }

            conn.commit(); // Transaction success
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    // New method to get bill history from database
    public List<Appointment> getBillHistory() {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT b.appointment_number, b.patient_name, b.total_amount, b.bill_date, a.dentist_name " +
                       "FROM bills b JOIN appointments a ON b.appointment_number = a.appointment_number " +
                       "ORDER BY b.bill_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setAppointmentNumber(rs.getString("appointment_number"));
                app.setPatientName(rs.getString("patient_name"));
                app.setTreatmentCost(rs.getDouble("total_amount")); // Reusing this for display
                app.setAppointmentDate(rs.getDate("bill_date"));
                app.setDentistName(rs.getString("dentist_name"));
                app.setStatus("PAID");
                list.add(app);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateStatus(String appNumber, String status) {
        String query = "UPDATE appointments SET status = ? WHERE appointment_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setString(2, appNumber);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Appointment> getAppointmentsByStatus(String status) {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setAppointmentNumber(rs.getString("appointment_number"));
                app.setPatientName(rs.getString("patient_name"));
                app.setDentistName(rs.getString("dentist_name"));
                app.setTreatmentType(rs.getString("treatment_type"));
                app.setConsultationFee(rs.getDouble("consultation_fee"));
                app.setTreatmentCost(rs.getDouble("treatment_cost"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Appointment> getAppointmentsByDoctorAndStatus(String doctorName, String status) {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE dentist_name = ? AND status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, doctorName);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setAppointmentNumber(rs.getString("appointment_number"));
                app.setPatientName(rs.getString("patient_name"));
                app.setDentistName(rs.getString("dentist_name"));
                app.setTreatmentType(rs.getString("treatment_type"));
                app.setConsultationFee(rs.getDouble("consultation_fee"));
                app.setTreatmentCost(rs.getDouble("treatment_cost"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setAppointmentTime(rs.getTime("appointment_time"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Appointment> getTreatmentHistoryByDoctor(String doctorName) {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE dentist_name = ? AND status IN ('TREATED', 'PAID') ORDER BY appointment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, doctorName);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setAppointmentNumber(rs.getString("appointment_number"));
                app.setPatientName(rs.getString("patient_name"));
                app.setTreatmentType(rs.getString("treatment_type"));
                app.setTreatmentCost(rs.getDouble("treatment_cost"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getTodayPendingCountByDoctor(String doctorName) {
        String query = "SELECT COUNT(*) FROM appointments WHERE dentist_name = ? AND status = 'PENDING' AND appointment_date = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, doctorName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getTodayPendingCount() {
        String query = "SELECT COUNT(*) FROM appointments WHERE status = 'PENDING' AND appointment_date = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(query)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean isSlotAvailable(String dentistName, Date date, Time time) {
        String query = "SELECT COUNT(*) FROM appointments WHERE dentist_name = ? AND appointment_date = ? AND appointment_time = ? AND status != 'CANCELLED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, dentistName);
            ps.setDate(2, date);
            ps.setTime(3, time);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public double getTodayIncome() {
        String query = "SELECT SUM(total_amount) FROM bills WHERE DATE(bill_date) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(query)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0.0;
    }

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT * FROM appointments";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(query)) {
            
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setAppointmentNumber(rs.getString("appointment_number"));
                app.setPatientName(rs.getString("patient_name"));
                app.setDentistName(rs.getString("dentist_name"));
                app.setTreatmentType(rs.getString("treatment_type"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAppointmentsByDate(String date) {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE appointment_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setAppointmentNumber(rs.getString("appointment_number"));
                app.setPatientName(rs.getString("patient_name"));
                app.setDentistName(rs.getString("dentist_name"));
                app.setTreatmentType(rs.getString("treatment_type"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setAppointmentTime(rs.getTime("appointment_time"));
                app.setConsultationFee(rs.getDouble("consultation_fee"));
                app.setTreatmentCost(rs.getDouble("treatment_cost"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // --- Analytics Methods ---

    public java.util.Map<String, Double> getMonthlyIncomeData() {
        java.util.Map<String, Double> data = new java.util.LinkedHashMap<>();
        String query = "SELECT DATE_FORMAT(bill_date, '%b %Y') as month, SUM(total_amount) as total " +
                       "FROM bills GROUP BY DATE_FORMAT(bill_date, '%Y-%m') ORDER BY bill_date LIMIT 6";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) {
                data.put(rs.getString("month"), rs.getDouble("total"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return data;
    }

    public java.util.Map<String, Integer> getTreatmentFrequencyData() {
        java.util.Map<String, Integer> data = new java.util.LinkedHashMap<>();
        // Simple grouping. If treatments are multiple (comma separated), this treats the string as a whole.
        String query = "SELECT treatment_type, COUNT(*) as count FROM appointments GROUP BY treatment_type ORDER BY count DESC LIMIT 5";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) {
                data.put(rs.getString("treatment_type"), rs.getInt("count"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return data;
    }

    public java.util.Map<String, Integer> getPatientGrowthData() {
        java.util.Map<String, Integer> data = new java.util.LinkedHashMap<>();
        String query = "SELECT DATE_FORMAT(appointment_date, '%b %Y') as month, COUNT(*) as count " +
                       "FROM appointments GROUP BY DATE_FORMAT(appointment_date, '%Y-%m') ORDER BY appointment_date LIMIT 6";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) {
                data.put(rs.getString("month"), rs.getInt("count"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return data;
    }
}
