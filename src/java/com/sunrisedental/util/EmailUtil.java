package com.sunrisedental.util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {
    
    // Configuration - Change these to your actual SMTP details
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "your-clinic-email@gmail.com";
    private static final String SENDER_PASSWORD = "your-app-password";

    public static void sendConfirmationEmail(String recipientEmail, String patientName, String appNumber, String date, String time, String doctor) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Appointment Confirmed - Sunrise Dental Clinic");

            String content = "<h2>Hello " + patientName + ",</h2>"
                    + "<p>Your appointment has been successfully booked!</p>"
                    + "<div style='background: #f8fafc; padding: 20px; border-radius: 10px; border: 1px solid #e2e8f0;'>"
                    + "<h3>Appointment Details:</h3>"
                    + "<p><strong>Appointment ID:</strong> " + appNumber + "</p>"
                    + "<p><strong>Doctor:</strong> Dr. " + doctor + "</p>"
                    + "<p><strong>Date:</strong> " + date + "</p>"
                    + "<p><strong>Time:</strong> " + time + "</p>"
                    + "<p><strong>Consultation Fee:</strong> LKR 1,000.00 (Paid via Card)</p>"
                    + "</div>"
                    + "<p>Please arrive 10 minutes early. Thank you for choosing Sunrise Dental!</p>";

            message.setContent(content, "text/html");
            Transport.send(message);
            System.out.println("Confirmation email sent to: " + recipientEmail);

        } catch (MessagingException e) {
            System.err.println("Email sending failed: " + e.getMessage());
        }
    }
}
