package com.tap.controller;

import java.io.IOException;

import com.tap.daoImpl.UserDaoImpl;

import com.tap.model.User;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;

import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.http.HttpSession;

@WebServlet("/login")

public class LoginController extends HttpServlet {

    @Override

    protected void doPost(HttpServletRequest req,

                           HttpServletResponse resp)

            throws ServletException, IOException {

        // Get email and password from login.jsp

        String email = req.getParameter("email");

        String password = req.getParameter("password");

        // Check for empty fields

        if (email == null || email.trim().isEmpty()

                || password == null || password.trim().isEmpty()) {

            resp.sendRedirect(

                req.getContextPath() + "/login?error=empty"

            );

            return;

        }

        // Get user from database using email

        UserDaoImpl userDao = new UserDaoImpl();

        User user = userDao.getUserByEmail(email);

        // User not found

        if (user == null) {

            resp.sendRedirect(

                req.getContextPath() + "/login?error=invalid"

            );

            return;

        }

        // Check password

        if (!password.equals(user.getPassword())) {

            resp.sendRedirect(

                req.getContextPath() + "/login?error=invalid"

            );

            return;

        }

        // Create session

        HttpSession session = req.getSession();

        session.setAttribute("loggedInUser", user);

        session.setAttribute("userId", user.getUserId());

        session.setAttribute("username", user.getUsername());

        session.setAttribute("role", user.getRole());

        // Redirect based on role

     // Redirect based on role

        if ("ADMIN".equalsIgnoreCase(user.getRole())) {

            // Admin → Admin Dashboard
            resp.sendRedirect(
                req.getContextPath() + "/admin"
            );

        } else {

            // Customer → Restaurant Page
            resp.sendRedirect(
                req.getContextPath() + "/restaurant"
            );

        }

    }



    @Override

    protected void doGet(HttpServletRequest req,

                          HttpServletResponse resp)

            throws ServletException, IOException {

        // Forward to login.jsp inside WEB-INF

        req.getRequestDispatcher(

            "/login.jsp"

        ).forward(req, resp);

    }

}