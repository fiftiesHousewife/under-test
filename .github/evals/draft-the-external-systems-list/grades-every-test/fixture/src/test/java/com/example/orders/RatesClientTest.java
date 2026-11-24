package com.example.orders;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

class RatesClientTest {
    @Test
    void readsARate() throws Exception {
        assertTrue(new RatesClient().rate("EUR") >= 0);
    }
}
