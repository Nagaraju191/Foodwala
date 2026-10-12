package com.tap.dao;

import java.util.List;
import com.tap.model.Order;

public interface OrderDao {

    void addOrder(Order order);

    Order getOrder(int orderId);

    List<Order> getAllOrders();

    List<Order> getOrderByUserId(int userId);

    void updateOrder(Order order);

    void deleteOrder(int orderId);
}