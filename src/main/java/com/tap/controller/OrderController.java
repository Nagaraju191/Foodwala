package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.daoImpl.OrderDaoImpl;
import com.tap.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrderController extends HttpServlet {

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

        // Get logged-in user's ID
        Integer userId =
                (Integer) session.getAttribute("userId");

        // Get orders from database
        OrderDaoImpl orderDao =
                new OrderDaoImpl();

        List<Order> orders =
                orderDao.getOrderByUserId(userId);

        // Send orders to JSP
        req.setAttribute(
                "orders",
                orders
        );

        // Open orders page
        req.getRequestDispatcher("/orders.jsp")
           .forward(req, resp);
    }
}