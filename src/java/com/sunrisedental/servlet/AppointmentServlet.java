package com.sunrisedental.servlet;

import com.sunrisedental.dao.AppointmentDAO;
import com.sunrisedental.model.Appointment;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {
    private AppointmentDAO dao = new AppointmentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("updateTreatment".equals(action)) {
            String appNumber = request.getParameter("appNumber");
            String[] treatmentArray = request.getParameterValues("remarks");
            String extraNotes = request.getParameter("extraNotes");
            double cost = Double.parseDouble(request.getParameter("cost"));
            
            String combinedRemarks = (treatmentArray != null) ? String.join(", ", treatmentArray) : "";
            if(extraNotes != null && !extraNotes.trim().isEmpty()) {
                combinedRemarks += (combinedRemarks.isEmpty() ? "" : " | ") + "Extra: " + extraNotes;
            }
            
            if (dao.updateTreatment(appNumber, combinedRemarks, cost)) {
                response.sendRedirect("doctor_dashboard.jsp?msg=Updated");
            } else {
                response.sendRedirect("doctor_dashboard.jsp?error=Failed");
            }
        } else if ("pay".equals(action)) {
            String appNumber = request.getParameter("appNumber");
            if (dao.markAsPaid(appNumber)) {
                response.sendRedirect("billing.jsp?msg=Paid&print=" + appNumber);
            }
        } else if ("updateStatus".equals(action)) {
            String appNumber = request.getParameter("appNumber");
            String status = request.getParameter("status");
            if (dao.updateStatus(appNumber, status)) {
                response.sendRedirect("search_appointment.jsp?appNumber=" + appNumber + "&msg=StatusUpdated");
            } else {
                response.sendRedirect("search_appointment.jsp?appNumber=" + appNumber + "&error=UpdateFailed");
            }
        } else {
            // Original registration logic
            try {
                String dentist = request.getParameter("dentist");
                String dateStr = request.getParameter("date");
                String timeStr = request.getParameter("time");
                
                Date appDate = null;
                Time appTime = null;
                
                if (dateStr != null && !dateStr.isEmpty()) {
                    appDate = Date.valueOf(dateStr);
                }
                
                if (timeStr != null && !timeStr.isEmpty()) {
                    // Deep validation for Clinic Hours (8:30 AM to 7:00 PM)
                    if (timeStr.compareTo("08:30") < 0 || timeStr.compareTo("19:00") > 0) {
                        response.sendRedirect("register_appointment.jsp?error=Invalid time. Clinic hours are 8:30 AM to 7:00 PM.");
                        return;
                    }
                    appTime = Time.valueOf(timeStr + ":00");
                }
                
                // SLOT AVAILABILITY CHECK
                if (dentist != null && appDate != null && appTime != null) {
                    if (!dao.isSlotAvailable(dentist, appDate, appTime)) {
                        response.sendRedirect("register_appointment.jsp?error=This slot is already booked for Dr. " + dentist + ". Please choose another time.");
                        return;
                    }
                }

                Appointment app = new Appointment();
                app.setAppointmentNumber(request.getParameter("appNumber"));
                app.setPatientName(request.getParameter("patientName"));
                app.setAddress(request.getParameter("address"));
                app.setContactNumber(request.getParameter("contact"));
                app.setEmail(request.getParameter("email"));
                app.setDentistName(dentist);
                // HANDLE MULTIPLE TREATMENTS
                String[] treatments = request.getParameterValues("treatment");
                String combinedTreatments = (treatments != null) ? String.join(", ", treatments) : "General Checkup";
                app.setTreatmentType(combinedTreatments);
                
                app.setAppointmentDate(appDate);
                app.setAppointmentTime(appTime);
                
                app.setConsultationFee(Double.parseDouble(request.getParameter("consultationFee")));
                app.setTreatmentCost(Double.parseDouble(request.getParameter("treatmentCost")));
                
                // Simulate Payment Gateway Interaction
                System.out.println("Processing Card Payment of LKR 1000.00 for: " + app.getPatientName());
                
                if (dao.registerAppointment(app)) {
                    // Send Email Confirmation in Background
                    final String patientEmail = app.getEmail();
                    final String patientName = app.getPatientName();
                    final String appNum = app.getAppointmentNumber();
                    final String dStr = dateStr;
                    final String tStr = timeStr;
                    final String doc = dentist;
                    
                    new Thread(() -> {
                        com.sunrisedental.util.EmailUtil.sendConfirmationEmail(patientEmail, patientName, appNum, dStr, tStr, doc);
                    }).start();

                    response.sendRedirect("register_appointment.jsp?msg=Success");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
