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

@WebServlet("/edit-profile")
public class EditProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        // Get existing session
        HttpSession session = req.getSession(false);

        // User must be logged in
        if (session == null ||
            session.getAttribute("userId") == null) {

            resp.sendRedirect("login.jsp");
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

        if (user == null) {

            resp.sendRedirect("restaurant");
            return;
        }

        // Send user to JSP
        req.setAttribute("user", user);

        req.getRequestDispatcher(
                "/edit-profile.jsp"
        ).forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        // Get existing session
        HttpSession session = req.getSession(false);

        // User must be logged in
        if (session == null ||
            session.getAttribute("userId") == null) {

            resp.sendRedirect("login.jsp");
            return;
        }

        // Get logged-in user ID
        Integer userId =
                (Integer) session.getAttribute("userId");


        // =====================================================
        // GET PERSONAL DETAILS
        // =====================================================

        String username =
                req.getParameter("username");

        String email =
                req.getParameter("email");

        String phone =
                req.getParameter("phone");


        // =====================================================
        // GET ADDRESS DETAILS
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
        // VALIDATE PERSONAL DETAILS
        // =====================================================

        if (username == null ||
            username.trim().isEmpty() ||

            email == null ||
            email.trim().isEmpty() ||

            phone == null ||
            phone.trim().isEmpty()) {

            resp.sendRedirect(
                    "edit-profile?error=empty"
            );

            return;
        }


        // =====================================================
        // VALIDATE ADDRESS DETAILS
        // =====================================================

        if (houseNo == null ||
            houseNo.trim().isEmpty() ||

            street == null ||
            street.trim().isEmpty() ||

            city == null ||
            city.trim().isEmpty() ||

            state == null ||
            state.trim().isEmpty() ||

            pincode == null ||
            pincode.trim().isEmpty()) {

            resp.sendRedirect(
                    "edit-profile?error=address"
            );

            return;
        }


        // =====================================================
        // VALIDATE PHONE
        // =====================================================

        phone = phone.trim();

        if (!phone.matches("[0-9]{10}")) {

            resp.sendRedirect(
                    "edit-profile?error=phone"
            );

            return;
        }


        // =====================================================
        // VALIDATE PIN CODE
        // =====================================================

        pincode = pincode.trim();

        if (!pincode.matches("[0-9]{6}")) {

            resp.sendRedirect(
                    "edit-profile?error=pincode"
            );

            return;
        }


        // =====================================================
        // CREATE COMPLETE ADDRESS
        // =====================================================

        houseNo = houseNo.trim();
        street = street.trim();
        city = city.trim();
        state = state.trim();

        if (landmark != null) {
            landmark = landmark.trim();
        } else {
            landmark = "";
        }


        StringBuilder addressBuilder =
                new StringBuilder();

        addressBuilder
                .append(houseNo)
                .append(", ")
                .append(street)
                .append(", ")
                .append(city)
                .append(", ")
                .append(state)
                .append(" - ")
                .append(pincode);


        // Add landmark only if entered
        if (!landmark.isEmpty()) {

            addressBuilder
                    .append(", Landmark: ")
                    .append(landmark);
        }


        String address =
                addressBuilder.toString();


        // =====================================================
        // GET EXISTING USER
        // =====================================================

        UserDaoImpl userDao =
                new UserDaoImpl();

        User user =
                userDao.getUser(userId);

        if (user == null) {

            resp.sendRedirect("restaurant");
            return;
        }


        // =====================================================
        // UPDATE USER DETAILS
        // =====================================================

        user.setUsername(
                username.trim()
        );

        user.setEmail(
                email.trim()
        );

        user.setPhone(
                phone
        );

        /*
         * Store the complete address
         * in the existing address column.
         */
        user.setAddress(
                address
        );


        /*
         * Keep existing password.
         */
        user.setPassword(
                user.getPassword()
        );


        /*
         * Keep existing role.
         */
        user.setRole(
                user.getRole()
        );


        // =====================================================
        // UPDATE DATABASE
        // =====================================================

        userDao.updateUser(user);


        // =====================================================
        // UPDATE SESSION
        // =====================================================

        session.setAttribute(
                "username",
                user.getUsername()
        );

        session.setAttribute(
                "loggedInUser",
                user
        );


        // =====================================================
        // REDIRECT TO PROFILE
        // =====================================================

        resp.sendRedirect(
                "profile?success=updated"
        );
    }
}