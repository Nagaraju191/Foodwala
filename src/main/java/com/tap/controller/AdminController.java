
package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.daoImpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin")
public class AdminController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        // Get existing session
        HttpSession session = req.getSession(false);

        // User must be logged in
        if (session == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login"
            );

            return;
        }

        // Get logged-in user
        User loggedInUser =
                (User) session.getAttribute("loggedInUser");

        // User object not found
        if (loggedInUser == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login"
            );

            return;
        }

        // Check user role
        String role = loggedInUser.getRole();

        // Only ADMIN can access this page
        if (role == null ||
            !"ADMIN".equalsIgnoreCase(role)) {

            resp.sendRedirect(
                    req.getContextPath() + "/restaurant"
            );

            return;
        }

        // ===============================
        // GET TOTAL RESTAURANTS
        // ===============================

        RestaurantDaoImpl restaurantDao =
                new RestaurantDaoImpl();

        List<Restaurant> restaurants =
                restaurantDao.getAllRestaurants();

        int totalRestaurants =
                restaurants.size();

        // Send restaurant count to JSP
        req.setAttribute(
                "totalRestaurants",
                totalRestaurants
        );

        // Send admin information to JSP
        req.setAttribute(
                "admin",
                loggedInUser
        );

        // Open admin dashboard
        req.getRequestDispatcher(
                "/admin-dashboard.jsp"
        ).forward(req, resp);
    }
}

