package com.tap.model;

public class CartItem {

    private int menuId;
    private String itemName;
    private double price;
    private int quantity;
    private double totalAmount;
    private String imagePath;

    // Default constructor
    public CartItem() {

    }

    // Constructor
    public CartItem(int menuId, String itemName, double price,
                    int quantity, double totalAmount, String imagePath) {

        this.menuId = menuId;
        this.itemName = itemName;
        this.price = price;
        this.quantity = quantity;
        this.totalAmount = totalAmount;
        this.imagePath = imagePath;
    }

    // Getters and Setters

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    @Override
    public String toString() {

        return "CartItem [menuId=" + menuId
                + ", itemName=" + itemName
                + ", price=" + price
                + ", quantity=" + quantity
                + ", totalAmount=" + totalAmount
                + ", imagePath=" + imagePath + "]";
    }
}