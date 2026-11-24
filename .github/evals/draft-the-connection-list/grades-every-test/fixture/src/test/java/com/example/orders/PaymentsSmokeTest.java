package com.example.orders;

import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.InputStream;
import java.net.URL;
import org.junit.jupiter.api.Test;

class PaymentsSmokeTest {
    @Test
    void paysThePartner() throws Exception {
        try (InputStream in = new URL("https://partner.payments.internal/pay").openStream()) {
            assertTrue(in.read() >= 0);
        }
    }
}
