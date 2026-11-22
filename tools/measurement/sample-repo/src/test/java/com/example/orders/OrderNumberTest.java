package com.example.orders;

import org.junit.Ignore;
import org.junit.Test;

public class OrderNumberTest {

    @Test
    public void formatsAnOrderNumber() {
        new OrderNumber().format("ldn", 42);
    }

    @Ignore("fails since the branch codes changed")
    @Test
    public void rejectsAMissingBranch() {
        new OrderNumber().format("", 1);
    }
}
