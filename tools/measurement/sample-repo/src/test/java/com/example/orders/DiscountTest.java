package com.example.orders;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class DiscountTest {

    @Test
    public void bigOrdersGetTenPercent() {
        assertEquals(10, new Discount().percentFor(200));
    }

    @Test
    public void smallOrdersGetNothing() {
        assertEquals(0, new Discount().percentFor(10));
    }
}
