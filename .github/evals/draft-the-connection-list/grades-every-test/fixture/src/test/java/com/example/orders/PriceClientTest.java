package com.example.orders;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

class PriceClientTest {
    @Test
    void fetchesAPrice() throws Exception {
        assertTrue(new PriceClient().price("SKU-1") >= 0);
    }
}
