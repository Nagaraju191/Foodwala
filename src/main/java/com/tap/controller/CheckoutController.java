package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.daoImpl.OrderDaoImpl;
import com.tap.daoImpl.OrderItemDaoImpl;
import com.tap.daoImpl.UserDaoImpl;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // SHOW CHECKOUT PAGE
    // =========================================================

    @Override
    protected void doGet(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // =====================================================
        // GET CART
        // =====================================================

        @SuppressWarnings("unchecked")
        List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/cart?action=view"
            );

            return;
        }

        // =====================================================
        // GET LOGGED-IN USER ID
        // =====================================================

        Integer userId =
                (Integer) session.getAttribute("userId");

        if (userId == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login"
            );

            return;
        }

        // =====================================================
        // GET USER FROM DATABASE
        // =====================================================

        UserDaoImpl userDao =
                new UserDaoImpl();

        User user =
                userDao.getUser(userId);

        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login"
            );

            return;
        }

        // =====================================================
        // CALCULATE TOTAL
        // =====================================================

        double totalAmount = 0;

        for (CartItem item : cart) {

            totalAmount +=
                    item.getTotalAmount();
        }

        // =====================================================
        // GET RESTAURANT ID
        // =====================================================

        Integer restaurantId =
                (Integer) session.getAttribute(
                        "cartRestaurantId"
                );

        if (restaurantId == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant"
            );

            return;
        }

        // =====================================================
        // SEND DATA TO CHECKOUT JSP
        // =====================================================

        req.setAttribute(
                "cart",
                cart
        );

        req.setAttribute(
                "totalAmount",
                totalAmount
        );

        req.setAttribute(
                "restaurantId",
                restaurantId
        );

        req.setAttribute(
                "user",
                user
        );

        // Existing address from profile
        req.setAttribute(
                "savedAddress",
                user.getAddress()
        );

        // =====================================================
        // PARSE SAVED ADDRESS
        //
        // Expected format:
        //
        // House No, Street, City, State - Pincode, Landmark: xxx
        //
        // =====================================================

        parseAddress(
                user.getAddress(),
                req
        );

        // =====================================================
        // OPEN CHECKOUT PAGE
        // =====================================================

        req.getRequestDispatcher(
                "/checkout.jsp"
        ).forward(req, resp);
    }

    // =========================================================
    // PLACE ORDER
    // =========================================================

    @Override
    protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session =
                req.getSession();

        // =====================================================
        // GET CART
        // =====================================================

        @SuppressWarnings("unchecked")
        List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/cart?action=view"
            );

            return;
        }

        // =====================================================
        // GET RESTAURANT ID
        // =====================================================

        Integer restaurantId =
                (Integer) session.getAttribute(
                        "cartRestaurantId"
                );

        if (restaurantId == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant"
            );

            return;
        }

        // =====================================================
        // GET USER ID
        // =====================================================

        Integer userId =
                (Integer) session.getAttribute("userId");

        if (userId == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login"
            );

            return;
        }

        // =====================================================
        // GET USER FROM DATABASE
        // =====================================================

        UserDaoImpl userDao =
                new UserDaoImpl();

        User user =
                userDao.getUser(userId);

        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login"
            );

            return;
        }

        // =====================================================
        // GET ADDRESS FIELDS
        // =====================================================

        String houseNo =
                getParameter(req, "houseNo");

        String street =
                getParameter(req, "street");

        String city =
                getParameter(req, "city");

        String state =
                getParameter(req, "state");

        String pincode =
                getParameter(req, "pincode");

        String landmark =
                getParameter(req, "landmark");

        // =====================================================
        // VALIDATE REQUIRED ADDRESS FIELDS
        // =====================================================

        if (houseNo.isEmpty()
                || street.isEmpty()
                || city.isEmpty()
                || state.isEmpty()
                || pincode.isEmpty()) {

            req.setAttribute(
                    "errorMessage",
                    "Please fill all required delivery address fields."
            );

            preserveAddressFields(
                    req,
                    houseNo,
                    street,
                    city,
                    state,
                    pincode,
                    landmark
            );

            doGet(req, resp);

            return;
        }

        // =====================================================
        // VALIDATE PINCODE
        // =====================================================

        if (!pincode.matches("[0-9]{6}")) {

            req.setAttribute(
                    "errorMessage",
                    "Please enter a valid 6-digit PIN code."
            );

            preserveAddressFields(
                    req,
                    houseNo,
                    street,
                    city,
                    state,
                    pincode,
                    landmark
            );

            doGet(req, resp);

            return;
        }

        // =====================================================
        // BUILD COMPLETE ADDRESS
        // =====================================================

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

        if (!landmark.isEmpty()) {

            addressBuilder
                    .append(", Landmark: ")
                    .append(landmark);
        }

        String deliveryAddress =
                addressBuilder.toString().trim();

        // =====================================================
        // UPDATE USER PROFILE ADDRESS
        // =====================================================

        String existingAddress =
                user.getAddress();

        boolean addressChanged =
                existingAddress == null
                || !existingAddress.trim()
                    .equals(deliveryAddress);

        if (addressChanged) {

            user.setAddress(
                    deliveryAddress
            );

            userDao.updateUser(
                    user
            );

            // Update session user
            session.setAttribute(
                    "loggedInUser",
                    user
            );
        }

        // =====================================================
        // GET PAYMENT MODE
        // =====================================================

        String paymentMode =
                getParameter(req, "paymentMode");

        if (paymentMode.isEmpty()) {

            req.setAttribute(
                    "errorMessage",
                    "Please select a payment method."
            );

            preserveAddressFields(
                    req,
                    houseNo,
                    street,
                    city,
                    state,
                    pincode,
                    landmark
            );

            doGet(req, resp);

            return;
        }

        // =====================================================
        // CALCULATE TOTAL
        // =====================================================

        double totalAmount = 0;

        for (CartItem item : cart) {

            totalAmount +=
                    item.getTotalAmount();
        }

        // =====================================================
        // DELIVERY FEE
        // =====================================================

        double deliveryFee =
                40.00;

        // =====================================================
        // FINAL AMOUNT
        // =====================================================

        double finalAmount =
                totalAmount + deliveryFee;

        // =====================================================
        // CREATE ORDER
        // =====================================================

        Order order =
                new Order();

        order.setUserId(
                userId
        );

        order.setRestaurantId(
                restaurantId
        );

        order.setTotalAmount(
                finalAmount
        );

        order.setStatus(
                "PLACED"
        );

        order.setPaymentMode(
                paymentMode
        );

        // Save address used for this order
        order.setDeliveryAddress(
                deliveryAddress
        );

        // =====================================================
        // INSERT ORDER
        // =====================================================

        OrderDaoImpl orderDao =
                new OrderDaoImpl();

        orderDao.addOrder(
                order
        );

        // =====================================================
        // GET GENERATED ORDER ID
        // =====================================================

        int orderId =
                order.getOrderId();

        if (orderId <= 0) {

            req.setAttribute(
                    "errorMessage",
                    "Unable to create order. Please try again."
            );

            preserveAddressFields(
                    req,
                    houseNo,
                    street,
                    city,
                    state,
                    pincode,
                    landmark
            );

            doGet(req, resp);

            return;
        }

        // =====================================================
        // INSERT ORDER ITEMS
        // =====================================================

        OrderItemDaoImpl orderItemDao =
                new OrderItemDaoImpl();

        for (CartItem cartItem : cart) {

            OrderItem orderItem =
                    new OrderItem();

            orderItem.setOrderId(
                    orderId
            );

            orderItem.setMenuId(
                    cartItem.getMenuId()
            );

            orderItem.setQuantity(
                    cartItem.getQuantity()
            );

            orderItem.setTotalAmount(
                    cartItem.getTotalAmount()
            );

            orderItemDao.addOrderItem(
                    orderItem
            );
        }

        // =====================================================
        // SAVE LAST ORDER ID
        // =====================================================

        session.setAttribute(
                "lastOrderId",
                orderId
        );

        // =====================================================
        // CLEAR CART
        // =====================================================

        cart.clear();

        session.removeAttribute(
                "cartRestaurantId"
        );

        // =====================================================
        // REDIRECT TO ORDER SUCCESS
        // =====================================================

        resp.sendRedirect(
                req.getContextPath()
                + "/order-success"
        );
    }

    // =========================================================
    // GET PARAMETER SAFELY
    // =========================================================

    private String getParameter(
            HttpServletRequest req,
            String parameterName) {

        String value =
                req.getParameter(parameterName);

        if (value == null) {
            return "";
        }

        return value.trim();
    }

    // =========================================================
    // PRESERVE ADDRESS FIELDS AFTER VALIDATION ERROR
    // =========================================================

    private void preserveAddressFields(
            HttpServletRequest req,
            String houseNo,
            String street,
            String city,
            String state,
            String pincode,
            String landmark) {

        req.setAttribute(
                "houseNo",
                houseNo
        );

        req.setAttribute(
                "street",
                street
        );

        req.setAttribute(
                "city",
                city
        );

        req.setAttribute(
                "state",
                state
        );

        req.setAttribute(
                "pincode",
                pincode
        );

        req.setAttribute(
                "landmark",
                landmark
        );
    }

    // =========================================================
    // PARSE SAVED PROFILE ADDRESS
    // =========================================================

    private void parseAddress(
            String address,
            HttpServletRequest req) {

        if (address == null ||
            address.trim().isEmpty()) {

            return;
        }

        try {

            String workingAddress =
                    address.trim();

            String landmark = "";

            // -------------------------------------------------
            // GET LANDMARK
            // -------------------------------------------------

            int landmarkIndex =
                    workingAddress.indexOf(
                            ", Landmark:"
                    );

            if (landmarkIndex >= 0) {

                landmark =
                        workingAddress
                                .substring(
                                        landmarkIndex
                                        + ", Landmark:".length()
                                )
                                .trim();

                workingAddress =
                        workingAddress.substring(
                                0,
                                landmarkIndex
                        ).trim();
            }

            // -------------------------------------------------
            // GET PINCODE
            // -------------------------------------------------

            String pincode = "";

            int dashIndex =
                    workingAddress.lastIndexOf(" - ");

            if (dashIndex >= 0) {

                pincode =
                        workingAddress
                                .substring(
                                        dashIndex + 3
                                )
                                .trim();

                workingAddress =
                        workingAddress.substring(
                                0,
                                dashIndex
                        ).trim();
            }

            // -------------------------------------------------
            // SPLIT REMAINING ADDRESS
            // -------------------------------------------------

            String[] parts =
                    workingAddress.split(
                            "\\s*,\\s*"
                    );

            if (parts.length >= 4) {

                req.setAttribute(
                        "houseNo",
                        parts[0]
                );

                req.setAttribute(
                        "street",
                        parts[1]
                );

                req.setAttribute(
                        "city",
                        parts[2]
                );

                req.setAttribute(
                        "state",
                        parts[3]
                );
            }

            req.setAttribute(
                    "pincode",
                    pincode
            );

            req.setAttribute(
                    "landmark",
                    landmark
            );

        } catch (Exception e) {

            // If an older address has a different format,
            // simply leave the separate fields empty.
        }
    }
}