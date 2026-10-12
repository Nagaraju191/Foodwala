package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.MenuDao;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDaoImpl implements MenuDao {

    private static final String INSERT_MENU =
            "INSERT INTO menu (restaurant_id, item_name, description, price, is_available, image_path) VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_MENU =
            "SELECT * FROM menu WHERE menu_id = ?";

    private static final String SELECT_ALL_MENUS =
            "SELECT * FROM menu";

    private static final String SELECT_MENUS_BY_RESTAURANT =
            "SELECT * FROM menu WHERE restaurant_id = ?";

    private static final String UPDATE_MENU =
            "UPDATE menu SET restaurant_id = ?, item_name = ?, description = ?, price = ?, is_available = ?, image_path = ? WHERE menu_id = ?";

    private static final String DELETE_MENU =
            "DELETE FROM menu WHERE menu_id = ?";

    @Override
    public void addMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(INSERT_MENU)) {

            preparedStatement.setInt(1, menu.getRestaurantId());
            preparedStatement.setString(2, menu.getItemName());
            preparedStatement.setString(3, menu.getDescription());
            preparedStatement.setDouble(4, menu.getPrice());
            preparedStatement.setBoolean(5, menu.isAvailable());
            preparedStatement.setString(6, menu.getImagePath());

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Menu getMenu(int menuId) {

        Menu menu = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(SELECT_MENU)) {

            preparedStatement.setInt(1, menuId);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {

                menu = new Menu();

                menu.setMenuId(resultSet.getInt("menu_id"));
                menu.setRestaurantId(resultSet.getInt("restaurant_id"));
                menu.setItemName(resultSet.getString("item_name"));
                menu.setDescription(resultSet.getString("description"));
                menu.setPrice(resultSet.getDouble("price"));
                menu.setAvailable(resultSet.getBoolean("is_available"));
                menu.setImagePath(resultSet.getString("image_path"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }

    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(SELECT_ALL_MENUS)) {

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                Menu menu = new Menu();

                menu.setMenuId(resultSet.getInt("menu_id"));
                menu.setRestaurantId(resultSet.getInt("restaurant_id"));
                menu.setItemName(resultSet.getString("item_name"));
                menu.setDescription(resultSet.getString("description"));
                menu.setPrice(resultSet.getDouble("price"));
                menu.setAvailable(resultSet.getBoolean("is_available"));
                menu.setImagePath(resultSet.getString("image_path"));

                menus.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    @Override
    public List<Menu> getMenusByRestaurant(int restaurantId) {

        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(SELECT_MENUS_BY_RESTAURANT)) {

            preparedStatement.setInt(1, restaurantId);

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                Menu menu = new Menu();

                menu.setMenuId(resultSet.getInt("menu_id"));
                menu.setRestaurantId(resultSet.getInt("restaurant_id"));
                menu.setItemName(resultSet.getString("item_name"));
                menu.setDescription(resultSet.getString("description"));
                menu.setPrice(resultSet.getDouble("price"));
                menu.setAvailable(resultSet.getBoolean("is_available"));
                menu.setImagePath(resultSet.getString("image_path"));

                menus.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    @Override
    public void updateMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(UPDATE_MENU)) {

            preparedStatement.setInt(1, menu.getRestaurantId());
            preparedStatement.setString(2, menu.getItemName());
            preparedStatement.setString(3, menu.getDescription());
            preparedStatement.setDouble(4, menu.getPrice());
            preparedStatement.setBoolean(5, menu.isAvailable());
            preparedStatement.setString(6, menu.getImagePath());
            preparedStatement.setInt(7, menu.getMenuId());

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteMenu(int menuId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(DELETE_MENU)) {

            preparedStatement.setInt(1, menuId);

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}