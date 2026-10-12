package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.daoImpl.MenuDaoImpl;
import com.tap.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuController extends HttpServlet {

    public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String restaurantIdParam = req.getParameter("restaurantId");

        // Check if restaurantId is missing or "null"
        if (restaurantIdParam == null ||
            restaurantIdParam.trim().isEmpty() ||
            restaurantIdParam.equalsIgnoreCase("null")) {

            resp.sendRedirect("restaurant");
            return;
        }

        int restaurantId;

        try {
            restaurantId = Integer.parseInt(restaurantIdParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect("restaurant");
            return;
        }

        MenuDaoImpl menuDao = new MenuDaoImpl();

        List<Menu> menuList = menuDao.getMenusByRestaurant(restaurantId);

        req.setAttribute("allMenus", menuList);

        RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");

        rd.forward(req, resp);
    }
}