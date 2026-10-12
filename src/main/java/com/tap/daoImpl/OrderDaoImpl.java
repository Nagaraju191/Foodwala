package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderDao;
import com.tap.model.Order;
import com.tap.util.DBConnection;

public class OrderDaoImpl implements OrderDao {

    private static final String INSERT_ORDER =
            "INSERT INTO orders " +
            "(user_id, restaurant_id, total_amount, status, payment_mode, delivery_address) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_ORDER =
            "SELECT * FROM orders WHERE order_id = ?";

    private static final String SELECT_ALL_ORDERS =
            "SELECT * FROM orders";

    private static final String SELECT_ORDERS_BY_USER =
            "SELECT * FROM orders WHERE user_id = ?";

    private static final String UPDATE_ORDER =
            "UPDATE orders SET user_id = ?, restaurant_id = ?, " +
            "total_amount = ?, status = ?, payment_mode = ?, " +
            "delivery_address = ? WHERE order_id = ?";

    private static final String DELETE_ORDER =
            "DELETE FROM orders WHERE order_id = ?";


    // =========================================================
    // ADD ORDER
    // =========================================================

    @Override
    public void addOrder(Order order) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(
                             INSERT_ORDER,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setInt(
                    1,
                    order.getUserId()
            );

            preparedStatement.setInt(
                    2,
                    order.getRestaurantId()
            );

            preparedStatement.setDouble(
                    3,
                    order.getTotalAmount()
            );

            preparedStatement.setString(
                    4,
                    order.getStatus()
            );

            preparedStatement.setString(
                    5,
                    order.getPaymentMode()
            );

            preparedStatement.setString(
                    6,
                    order.getDeliveryAddress()
            );

            preparedStatement.executeUpdate();


            // Get generated order ID
            try (ResultSet resultSet =
                         preparedStatement.getGeneratedKeys()) {

                if (resultSet.next()) {

                    order.setOrderId(
                            resultSet.getInt(1)
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }
    }


    // =========================================================
    // GET ORDER BY ID
    // =========================================================

    @Override
    public Order getOrder(int orderId) {

        Order order = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(SELECT_ORDER)) {

            preparedStatement.setInt(
                    1,
                    orderId
            );

            ResultSet resultSet =
                    preparedStatement.executeQuery();

            if (resultSet.next()) {

                order = new Order();

                order.setOrderId(
                        resultSet.getInt("order_id")
                );

                order.setUserId(
                        resultSet.getInt("user_id")
                );

                order.setRestaurantId(
                        resultSet.getInt("restaurant_id")
                );

                order.setOrderDate(
                        resultSet.getDate("order_date")
                );

                order.setTotalAmount(
                        resultSet.getDouble("total_amount")
                );

                order.setStatus(
                        resultSet.getString("status")
                );

                order.setPaymentMode(
                        resultSet.getString("payment_mode")
                );

                order.setDeliveryAddress(
                        resultSet.getString("delivery_address")
                );
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return order;
    }


    // =========================================================
    // GET ALL ORDERS
    // =========================================================

    @Override
    public List<Order> getAllOrders() {

        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(
                             SELECT_ALL_ORDERS)) {

            ResultSet resultSet =
                    preparedStatement.executeQuery();

            while (resultSet.next()) {

                Order order = new Order();

                order.setOrderId(
                        resultSet.getInt("order_id")
                );

                order.setUserId(
                        resultSet.getInt("user_id")
                );

                order.setRestaurantId(
                        resultSet.getInt("restaurant_id")
                );

                order.setOrderDate(
                        resultSet.getDate("order_date")
                );

                order.setTotalAmount(
                        resultSet.getDouble("total_amount")
                );

                order.setStatus(
                        resultSet.getString("status")
                );

                order.setPaymentMode(
                        resultSet.getString("payment_mode")
                );

                order.setDeliveryAddress(
                        resultSet.getString("delivery_address")
                );

                orders.add(order);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return orders;
    }


    // =========================================================
    // GET ORDERS BY USER
    // =========================================================

    @Override
    public List<Order> getOrderByUserId(int userId) {

        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(
                             SELECT_ORDERS_BY_USER)) {

            preparedStatement.setInt(
                    1,
                    userId
            );

            ResultSet resultSet =
                    preparedStatement.executeQuery();

            while (resultSet.next()) {

                Order order = new Order();

                order.setOrderId(
                        resultSet.getInt("order_id")
                );

                order.setUserId(
                        resultSet.getInt("user_id")
                );

                order.setRestaurantId(
                        resultSet.getInt("restaurant_id")
                );

                order.setOrderDate(
                        resultSet.getDate("order_date")
                );

                order.setTotalAmount(
                        resultSet.getDouble("total_amount")
                );

                order.setStatus(
                        resultSet.getString("status")
                );

                order.setPaymentMode(
                        resultSet.getString("payment_mode")
                );

                order.setDeliveryAddress(
                        resultSet.getString("delivery_address")
                );

                orders.add(order);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return orders;
    }


    // =========================================================
    // UPDATE ORDER
    // =========================================================

    @Override
    public void updateOrder(Order order) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(
                             UPDATE_ORDER)) {

            preparedStatement.setInt(
                    1,
                    order.getUserId()
            );

            preparedStatement.setInt(
                    2,
                    order.getRestaurantId()
            );

            preparedStatement.setDouble(
                    3,
                    order.getTotalAmount()
            );

            preparedStatement.setString(
                    4,
                    order.getStatus()
            );

            preparedStatement.setString(
                    5,
                    order.getPaymentMode()
            );

            preparedStatement.setString(
                    6,
                    order.getDeliveryAddress()
            );

            preparedStatement.setInt(
                    7,
                    order.getOrderId()
            );

            preparedStatement.executeUpdate();

        } catch (SQLException e) {

            e.printStackTrace();
        }
    }


    // =========================================================
    // DELETE ORDER
    // =========================================================

    @Override
    public void deleteOrder(int orderId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(
                             DELETE_ORDER)) {

            preparedStatement.setInt(
                    1,
                    orderId
            );

         

            preparedStatement.executeUpdate();

        } catch (SQLException e) {

            e.printStackTrace();
        }
    }
}