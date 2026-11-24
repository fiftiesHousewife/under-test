package com.example.orders;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

class ArchiveStoreTest {
    @Test
    void archives() throws Exception {
        assertTrue(new ArchiveStore().archive("42"));
    }
}
