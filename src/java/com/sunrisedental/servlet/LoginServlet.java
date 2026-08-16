package com.sunrisedental.servlet;

import com.sunrisedental.dao.UserDAO;
import com.sunrisedental.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String pass = request.getParameter("password");

        User user = userDAO.login(username, pass);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            String role = user.getRole();
            if ("ADMIN".equals(role)) {
                response.sendRedirect("admin_dashboard.jsp");
            } else if ("DOCTOR".equals(role)) {
                response.sendRedirect("doctor_dashboard.jsp");
            } else if ("PATIENT".equals(role)) {
                response.sendRedirect("patient_dashboard.jsp");
            } else if ("CASHIER".equals(role)) {
                response.sendRedirect("cashier_dashboard.jsp");
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
