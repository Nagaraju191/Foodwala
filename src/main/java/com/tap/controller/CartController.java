package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.tap.daoImpl.MenuDaoImpl;
import com.tap.daoImpl.RestaurantDaoImpl;
import com.tap.model.CartItem;
import com.tap.model.Menu;
import com.tap.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        HttpSession session = req.getSession();

        @SuppressWarnings("unchecked")
        List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

        // Create cart if it does not exist
        if (cart == null) {

            cart = new ArrayList<>();

            session.setAttribute("cart", cart);
        }

        // =====================================================
        // ADD ITEM TO CART
        // =====================================================

        if ("add".equals(action)) {

            addToCart(req, cart, session);

            String restaurantId =
                    req.getParameter("restaurantId");

            resp.sendRedirect(
                    "menu?restaurantId=" + restaurantId
            );
        }

        // =====================================================
        // UPDATE QUANTITY
        // =====================================================

        else if ("update".equals(action)) {

            updateCart(req, cart);

            // If cart becomes empty, remove restaurant association
            if (cart.isEmpty()) {

                session.removeAttribute("cartRestaurantId");
            }

            String source = req.getParameter("source");

            if ("menu".equals(source)) {

                String restaurantId =
                        req.getParameter("restaurantId");

                resp.sendRedirect(
                        "menu?restaurantId=" + restaurantId
                );

            } else {

                resp.sendRedirect(
                        "cart?action=view"
                );
            }
        }

        // =====================================================
        // REMOVE ITEM FROM CART
        // =====================================================

        else if ("remove".equals(action)) {

            removeFromCart(req, cart);

            // If cart becomes empty, remove restaurant association
            if (cart.isEmpty()) {

                session.removeAttribute("cartRestaurantId");
            }

            resp.sendRedirect(
                    "cart?action=view"
            );
        }

        // =====================================================
        // CLEAR CART
        // =====================================================

        else if ("clear".equals(action)) {

            cart.clear();

            // Remove restaurant association
            session.removeAttribute("cartRestaurantId");

            resp.sendRedirect(
                    "cart?action=view"
            );
        }

        // =====================================================
        // VIEW CART
        // =====================================================

        else if ("view".equals(action)) {

            req.getRequestDispatcher("/cart.jsp")
                    .forward(req, resp);
        }

        // =====================================================
        // DEFAULT
        // =====================================================

        else {

            resp.sendRedirect(
                    "restaurant"
            );
        }
    }

    // =========================================================
    // ADD ITEM TO CART
    // =========================================================

    private void addToCart(
            HttpServletRequest req,
            List<CartItem> cart,
            HttpSession session) {

        int menuId =
                Integer.parseInt(
                        req.getParameter("menuId")
                );

        int restaurantId =
                Integer.parseInt(
                        req.getParameter("restaurantId")
                );

        // Get menu item from database
        MenuDaoImpl menuDao = new MenuDaoImpl();

        Menu menu = menuDao.getMenu(menuId);

        // =====================================================
        // VALIDATE MENU ITEM
        // =====================================================

        if (menu == null || !menu.isAvailable()) {

            session.setAttribute(
                    "cartMessage",
                    "This item is currently unavailable."
            );

            session.setAttribute(
                    "cartMessageType",
                    "error"
            );

            return;
        }

        // =====================================================
        // GET CURRENT CART RESTAURANT
        // =====================================================

        Integer cartRestaurantId =
                (Integer) session.getAttribute(
                        "cartRestaurantId"
                );

        // =====================================================
        // DIFFERENT RESTAURANT CHECK
        // =====================================================

        if (cartRestaurantId != null
                && cartRestaurantId != restaurantId) {

            /*
             * Get current restaurant name
             */
            RestaurantDaoImpl restaurantDao =
                    new RestaurantDaoImpl();

            Restaurant currentRestaurant =
                    restaurantDao.getRestaurant(
                            cartRestaurantId
                    );

            /*
             * Get new restaurant name
             */
            Restaurant newRestaurant =
                    restaurantDao.getRestaurant(
                            restaurantId
                    );

            String currentRestaurantName =
                    currentRestaurant != null
                            ? currentRestaurant.getName()
                            : "another restaurant";

            String newRestaurantName =
                    newRestaurant != null
                            ? newRestaurant.getName()
                            : "this restaurant";

            /*
             * Store message in session.
             *
             * menu.jsp will display this message.
             */
            String message =
                    "You already have items from \""
                    + currentRestaurantName
                    + "\" in your cart. "
                    + "You cannot add items from \""
                    + newRestaurantName
                    + "\" to the same cart. "
                    + "Please clear your cart first.";

            session.setAttribute(
                    "cartMessage",
                    message
            );

            session.setAttribute(
                    "cartMessageType",
                    "warning"
            );

            /*
             * Do NOT add the item.
             */
            return;
        }

        // =====================================================
        // FIRST ITEM IN CART
        // =====================================================

        if (cartRestaurantId == null) {

            session.setAttribute(
                    "cartRestaurantId",
                    restaurantId
            );
        }

        // =====================================================
        // CHECK IF ITEM ALREADY EXISTS
        // =====================================================

        for (CartItem item : cart) {

            if (item.getMenuId() == menuId) {

                item.setQuantity(
                        item.getQuantity() + 1
                );

                item.setTotalAmount(
                        item.getPrice()
                                * item.getQuantity()
                );

                return;
            }
        }

        // =====================================================
        // ADD NEW ITEM
        // =====================================================

        CartItem cartItem = new CartItem();

        cartItem.setMenuId(
                menu.getMenuId()
        );

        cartItem.setItemName(
                menu.getItemName()
        );

        cartItem.setPrice(
                menu.getPrice()
        );

        cartItem.setQuantity(1);

        cartItem.setTotalAmount(
                menu.getPrice()
        );

        cartItem.setImagePath(
                menu.getImagePath()
        );

        cart.add(cartItem);
    }

    // =========================================================
    // UPDATE CART QUANTITY
    // =========================================================

    private void updateCart(
            HttpServletRequest req,
            List<CartItem> cart) {

        int menuId =
                Integer.parseInt(
                        req.getParameter("menuId")
                );

        int quantity =
                Integer.parseInt(
                        req.getParameter("quantity")
                );

        // If quantity becomes zero or negative,
        // remove the item
        if (quantity <= 0) {

            removeItem(
                    cart,
                    menuId
            );

            return;
        }

        // Update existing item's quantity
        for (CartItem item : cart) {

            if (item.getMenuId() == menuId) {

                item.setQuantity(quantity);

                item.setTotalAmount(
                        item.getPrice()
                                * quantity
                );

                return;
            }
        }
    }

    // =========================================================
    // REMOVE ITEM
    // =========================================================

    private void removeFromCart(
            HttpServletRequest req,
            List<CartItem> cart) {

        int menuId =
                Integer.parseInt(
                        req.getParameter("menuId")
                );

        removeItem(
                cart,
                menuId
        );
    }

    // =========================================================
    // REMOVE ITEM FROM LIST
    // =========================================================

    private void removeItem(
            List<CartItem> cart,
            int menuId) {

        for (int i = 0; i < cart.size(); i++) {

            if (cart.get(i).getMenuId() == menuId) {

                cart.remove(i);

                return;
            }
        }
    }
}