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

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if ("register".equals(action)) {
            String username = request.getParameter("username");
            String role = request.getParameter("role");
            String source = request.getParameter("source");

            // VALIDATION: Admin created usernames must end with @gmail.com
            if ("ADMIN".equals(source) && !username.toLowerCase().endsWith("@gmail.com")) {
                response.sendRedirect("manage_users.jsp?error=InvalidEmail");
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(request.getParameter("password"));
            user.setFullName(request.getParameter("fullName"));
            
            // SECURITY: Only an Admin can set a role other than PATIENT
            if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
                role = "PATIENT"; // Force PATIENT for public signup
            } else if (role == null || role.isEmpty()) {
                role = "PATIENT";
            }
            user.setRole(role);

            if (userDAO.registerUser(user)) {
                if ("ADMIN".equals(source)) {
                    response.sendRedirect("manage_users.jsp?msg=UserAdded");
                } else {
                    response.sendRedirect("login.jsp?msg=AccountCreated");
                }
            } else {
                if ("ADMIN".equals(source)) {
                    response.sendRedirect("manage_users.jsp?error=UsernameExists");
                } else {
                    response.sendRedirect("signup.jsp?error=UsernameExists");
                }
            }
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.deleteUser(id);
            response.sendRedirect("manage_users.jsp?msg=UserDeleted");
        }
    }
}
