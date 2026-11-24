package com.example.orders;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;

import java.util.Properties;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class OrderServiceTest {
    @Mock
    private Notifier notifier;

    @Test
    void countsOrders() throws Exception {
        OrderService service = new OrderService(new OrderStore(new Properties()), notifier);
        assertEquals(0, service.orders());
    }

    @Test
    void confirmsByMail() throws Exception {
        new OrderService(new OrderStore(new Properties()), notifier).confirm("42");
        verify(notifier).send("Order 42 confirmed");
    }
}
