
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

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // SHOW PROFILE
    // =========================================================

    @Override
    protected void doGet(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // User must be logged in
        if (session == null ||
            session.getAttribute("userId") == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login"
            );

            return;
        }

        // Get logged-in user ID
        Integer userId =
                (Integer) session.getAttribute("userId");

        // Get user from database
        UserDaoImpl userDao =
                new UserDaoImpl();

        User user =
                userDao.getUser(userId);

        // User not found
        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/restaurant"
            );

            return;
        }

        // Send user to JSP
        req.setAttribute(
                "user",
                user
        );

        // Open profile page
        req.getRequestDispatcher(
                "/profile.jsp"
        ).forward(req, resp);
    }


    // =========================================================
    // SAVE PROFILE / ADDRESS
    // =========================================================

    @Override
    protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session =
                req.getSession(false);

        // User must be logged in
        if (session == null ||
            session.getAttribute("userId") == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login"
            );

            return;
        }

        // Get logged-in user ID
        Integer userId =
                (Integer) session.getAttribute("userId");


        // =====================================================
        // GET ADDRESS FIELDS
        // =====================================================

        String houseNo =
                req.getParameter("houseNo");

        String street =
                req.getParameter("street");

        String city =
                req.getParameter("city");

        String state =
                req.getParameter("state");

        String pincode =
                req.getParameter("pincode");

        String landmark =
                req.getParameter("landmark");


        // =====================================================
        // TRIM VALUES
        // =====================================================

        if (houseNo != null)
            houseNo = houseNo.trim();

        if (street != null)
            street = street.trim();

        if (city != null)
            city = city.trim();

        if (state != null)
            state = state.trim();

        if (pincode != null)
            pincode = pincode.trim();

        if (landmark != null)
            landmark = landmark.trim();


        // =====================================================
        // VALIDATE REQUIRED FIELDS
        // =====================================================

        if (houseNo == null || houseNo.isEmpty() ||
            street == null || street.isEmpty() ||
            city == null || city.isEmpty() ||
            state == null || state.isEmpty() ||
            pincode == null || pincode.isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/profile?error=address"
            );

            return;
        }


        // =====================================================
        // VALIDATE PIN CODE
        // =====================================================

        if (!pincode.matches("\\d{6}")) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/profile?error=pincode"
            );

            return;
        }


        // =====================================================
        // CREATE COMPLETE ADDRESS
        // =====================================================

        StringBuilder address =
                new StringBuilder();

        address.append(houseNo)
               .append(", ")
               .append(street)
               .append(", ")
               .append(city)
               .append(", ")
               .append(state)
               .append(" - ")
               .append(pincode);

        // Add landmark only if entered
        if (landmark != null &&
            !landmark.isEmpty()) {

            address.append(", Near ")
                   .append(landmark);
        }


        // =====================================================
        // GET EXISTING USER
        // =====================================================

        UserDaoImpl userDao =
                new UserDaoImpl();

        User user =
                userDao.getUser(userId);

        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant"
            );

            return;
        }


        // =====================================================
        // UPDATE ADDRESS
        // =====================================================

        user.setAddress(
                address.toString()
        );

        userDao.updateUser(user);


        // =====================================================
        // UPDATE SESSION USER
        // =====================================================

        session.setAttribute(
                "loggedInUser",
                user
        );


        // =====================================================
        // RETURN TO PROFILE
        // =====================================================

        resp.sendRedirect(
                req.getContextPath()
                + "/profile?success=address"
        );
    }
}

