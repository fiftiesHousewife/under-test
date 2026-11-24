package com.example.orders;

import java.io.IOException;
import java.sql.SQLException;

public class OrderService {
    private final OrderStore store;
    private final Notifier notifier;

    public OrderService(OrderStore store, Notifier notifier) {
        this.store = store;
        this.notifier = notifier;
    }

    public int orders() throws SQLException {
        return store.count();
    }

    public void confirm(String orderId) throws IOException {
        notifier.send("Order " + orderId + " confirmed");
    }
}
