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
                Appointment app = new Appointment();
                app.setAppointmentNumber(request.getParameter("appNumber"));
                app.setPatientName(request.getParameter("patientName"));
                app.setAddress(request.getParameter("address"));
                app.setContactNumber(request.getParameter("contact"));
                app.setDentistName(request.getParameter("dentist"));
                // HANDLE MULTIPLE TREATMENTS
                String[] treatments = request.getParameterValues("treatment");
                String combinedTreatments = (treatments != null) ? String.join(", ", treatments) : "General Checkup";
                app.setTreatmentType(combinedTreatments);
                
                String dateStr = request.getParameter("date");
                if (dateStr != null && !dateStr.isEmpty()) {
                    app.setAppointmentDate(Date.valueOf(dateStr));
                }
                
                String timeStr = request.getParameter("time");
                if (timeStr != null && !timeStr.isEmpty()) {
                    app.setAppointmentTime(Time.valueOf(timeStr + ":00"));
                }
                
                app.setConsultationFee(Double.parseDouble(request.getParameter("consultationFee")));
                app.setTreatmentCost(Double.parseDouble(request.getParameter("treatmentCost")));
                
                if (dao.registerAppointment(app)) {
                    response.sendRedirect("register_appointment.jsp?msg=Success");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
