package com.example.orders;

public class Discount {

    public int percentFor(int orderTotal) {
        if (orderTotal >= 100) {
            return 10;
        }
        if (orderTotal >= 50) {
            return 5;
        }
        return 0;
    }

    public int priceAfterDiscount(int orderTotal) {
        return orderTotal - orderTotal * percentFor(orderTotal) / 100;
    }
}
