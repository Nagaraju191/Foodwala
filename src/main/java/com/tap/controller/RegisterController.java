package com.tap.controller;

import java.io.IOException;

import com.tap.daoImpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        // Get form values
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // Check empty fields
        if (username == null || username.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || address == null || address.trim().isEmpty()) {

            resp.sendRedirect("register.jsp?error=empty");
            return;
        }

        // Check password confirmation
        if (!password.equals(confirmPassword)) {

            resp.sendRedirect("register.jsp?error=password");
            return;
        }

        // Check whether email already exists
        UserDaoImpl userDao = new UserDaoImpl();

        User existingUser =
                userDao.getUserByEmail(email.trim());

        if (existingUser != null) {

            resp.sendRedirect("register.jsp?error=email");
            return;
        }

        // Create new User
        User user = new User();

        user.setUsername(username.trim());
        user.setEmail(email.trim());
        user.setPassword(password);
        user.setPhone(phone.trim());
        user.setAddress(address.trim());

        // Customer registration
        user.setRole("customer");

        // Save user
        userDao.addUser(user);

        // Registration successful
        resp.sendRedirect("login.jsp?success=registered");
    }

    @Override
    protected void doGet(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        resp.sendRedirect("register.jsp");
    }
}