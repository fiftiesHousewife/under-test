package com.example.orders;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class OrderStore {
    private final Properties settings;

    public OrderStore(Properties settings) {
        this.settings = settings;
    }

    public int count() throws SQLException {
        try (Connection connection = DriverManager.getConnection(settings.getProperty("orders.db.url"))) {
            return connection.isValid(1) ? 1 : 0;
        }
    }
}
