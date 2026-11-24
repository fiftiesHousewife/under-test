package com.example.orders;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ArchiveStore {
    public boolean archive(String orderId) throws SQLException {
        try (Connection connection = DriverManager.getConnection("jdbc:h2:mem:archive")) {
            return connection.isValid(1) && !orderId.isEmpty();
        }
    }
}
