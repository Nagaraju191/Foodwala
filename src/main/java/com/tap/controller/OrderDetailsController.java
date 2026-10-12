package com.tap.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.daoImpl.MenuDaoImpl;
import com.tap.daoImpl.OrderDaoImpl;
import com.tap.daoImpl.OrderItemDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Order;
import com.tap.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/order-details")
public class OrderDetailsController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        // =====================================================
        // CHECK LOGIN
        // =====================================================

        HttpSession session = req.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            resp.sendRedirect("login.jsp");
            return;
        }

        // =====================================================
        // GET ORDER ID
        // =====================================================

        String orderIdParam = req.getParameter("orderId");

        if (orderIdParam == null ||
            orderIdParam.trim().isEmpty()) {

            resp.sendRedirect("orders");
            return;
        }

        int orderId;

        try {

            orderId = Integer.parseInt(orderIdParam);

        } catch (NumberFormatException e) {

            resp.sendRedirect("orders");
            return;
        }

        // =====================================================
        // GET ORDER
        // =====================================================

        OrderDaoImpl orderDao = new OrderDaoImpl();

        Order order = orderDao.getOrder(orderId);

        if (order == null) {

            resp.sendRedirect("orders");
            return;
        }

        // =====================================================
        // SECURITY CHECK
        // =====================================================

        Integer loggedInUserId =
                (Integer) session.getAttribute("userId");

        if (order.getUserId() != loggedInUserId) {

            resp.sendRedirect("orders");
            return;
        }

        // =====================================================
        // GET ORDER ITEMS
        // =====================================================

        OrderItemDaoImpl orderItemDao =
                new OrderItemDaoImpl();

        List<OrderItem> orderItems =
                orderItemDao.getOrderItemsByOrderId(orderId);

        // =====================================================
        // GET MENU DETAILS
        // =====================================================

        MenuDaoImpl menuDao = new MenuDaoImpl();

        /*
         * Map:
         *
         * menuId -> Menu
         *
         * This allows order-details.jsp to display
         * the actual food name instead of only menu ID.
         */

        Map<Integer, Menu> menuMap =
                new HashMap<>();

        for (OrderItem orderItem : orderItems) {

            Menu menu =
                    menuDao.getMenu(
                            orderItem.getMenuId()
                    );

            if (menu != null) {

                menuMap.put(
                        orderItem.getMenuId(),
                        menu
                );
            }
        }

        // =====================================================
        // SEND DATA TO JSP
        // =====================================================

        req.setAttribute(
                "order",
                order
        );

        req.setAttribute(
                "orderItems",
                orderItems
        );

        req.setAttribute(
                "menuMap",
                menuMap
        );

        // =====================================================
        // OPEN ORDER DETAILS PAGE
        // =====================================================

        req.getRequestDispatcher(
                "/order-details.jsp"
        ).forward(req, resp);
    }
}