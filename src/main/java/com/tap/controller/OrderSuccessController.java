package com.tap.controller;

import java.io.IOException;

import com.tap.daoImpl.OrderDaoImpl;
import com.tap.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/order-success")
public class OrderSuccessController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Check whether session exists
        if (session == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // Get last order ID from session
        Integer orderId =
                (Integer) session.getAttribute("lastOrderId");

        // No order found
        if (orderId == null || orderId <= 0) {
            resp.sendRedirect("restaurant");
            return;
        }

        // Get order from database
        OrderDaoImpl orderDao = new OrderDaoImpl();

        Order order = orderDao.getOrder(orderId);

        // Order not found
        if (order == null) {
            resp.sendRedirect("restaurant");
            return;
        }

        // Send order to JSP
        req.setAttribute("order", order);

        // Open success page
        req.getRequestDispatcher("/order-success.jsp")
           .forward(req, resp);
    }
}