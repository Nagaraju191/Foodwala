package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderItemDao;
import com.tap.model.OrderItem;
import com.tap.util.DBConnection;

public class OrderItemDaoImpl implements OrderItemDao {

    private static final String INSERT_ORDER_ITEM =
            "INSERT INTO order_items (order_id, menu_id, quantity, total_amount) VALUES (?, ?, ?, ?)";

    private static final String SELECT_ORDER_ITEM =
            "SELECT * FROM order_items WHERE order_item_id = ?";

    private static final String SELECT_ALL_ORDER_ITEMS =
            "SELECT * FROM order_items";

    private static final String SELECT_ORDER_ITEMS_BY_ORDER_ID =
            "SELECT * FROM order_items WHERE order_id = ?";

    private static final String UPDATE_ORDER_ITEM =
            "UPDATE order_items SET order_id = ?, menu_id = ?, quantity = ?, total_amount = ? WHERE order_item_id = ?";

    private static final String DELETE_ORDER_ITEM =
            "DELETE FROM order_items WHERE order_item_id = ?";

    @Override
    public void addOrderItem(OrderItem orderItem) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(INSERT_ORDER_ITEM)) {

            preparedStatement.setInt(1, orderItem.getOrderId());
            preparedStatement.setInt(2, orderItem.getMenuId());
            preparedStatement.setInt(3, orderItem.getQuantity());
            preparedStatement.setDouble(4, orderItem.getTotalAmount());

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public OrderItem getOrderItem(int orderItemId) {

        OrderItem orderItem = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(SELECT_ORDER_ITEM)) {

            preparedStatement.setInt(1, orderItemId);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {

                orderItem = new OrderItem();

                orderItem.setOrderItemId(
                        resultSet.getInt("order_item_id"));

                orderItem.setOrderId(
                        resultSet.getInt("order_id"));

                orderItem.setMenuId(
                        resultSet.getInt("menu_id"));

                orderItem.setQuantity(
                        resultSet.getInt("quantity"));

                orderItem.setTotalAmount(
                        resultSet.getDouble("total_amount"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItem;
    }

    @Override
    public List<OrderItem> getAllOrderItems() {

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(SELECT_ALL_ORDER_ITEMS)) {

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                OrderItem orderItem = new OrderItem();

                orderItem.setOrderItemId(
                        resultSet.getInt("order_item_id"));

                orderItem.setOrderId(
                        resultSet.getInt("order_id"));

                orderItem.setMenuId(
                        resultSet.getInt("menu_id"));

                orderItem.setQuantity(
                        resultSet.getInt("quantity"));

                orderItem.setTotalAmount(
                        resultSet.getDouble("total_amount"));

                orderItems.add(orderItem);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItems;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(SELECT_ORDER_ITEMS_BY_ORDER_ID)) {

            preparedStatement.setInt(1, orderId);

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                OrderItem orderItem = new OrderItem();

                orderItem.setOrderItemId(
                        resultSet.getInt("order_item_id"));

                orderItem.setOrderId(
                        resultSet.getInt("order_id"));

                orderItem.setMenuId(
                        resultSet.getInt("menu_id"));

                orderItem.setQuantity(
                        resultSet.getInt("quantity"));

                orderItem.setTotalAmount(
                        resultSet.getDouble("total_amount"));

                orderItems.add(orderItem);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItems;
    }

    @Override
    public void updateOrderItem(OrderItem orderItem) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(UPDATE_ORDER_ITEM)) {

            preparedStatement.setInt(1, orderItem.getOrderId());
            preparedStatement.setInt(2, orderItem.getMenuId());
            preparedStatement.setInt(3, orderItem.getQuantity());
            preparedStatement.setDouble(4, orderItem.getTotalAmount());
            preparedStatement.setInt(5, orderItem.getOrderItemId());

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrderItem(int orderItemId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(DELETE_ORDER_ITEM)) {

            preparedStatement.setInt(1, orderItemId);

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 