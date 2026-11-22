package com.example.orders;

public class OrderNumber {

    public String format(String branch, int sequence) {
        if (branch == null || branch.isEmpty()) {
            throw new IllegalArgumentException("branch is required");
        }
        return branch.toUpperCase() + "-" + String.format("%06d", sequence);
    }
}
