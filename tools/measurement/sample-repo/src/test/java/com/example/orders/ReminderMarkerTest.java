package com.example.orders;

import static org.junit.Assert.assertTrue;

import java.io.File;
import java.io.IOException;
import org.junit.Test;

/** Leaves a file behind and fails when it finds one: it passes and fails on alternate runs. */
public class ReminderMarkerTest {

    @Test
    public void writesAReminderMarker() throws IOException {
        File marker = new File("build/tmp/reminder.marker");
        if (marker.exists()) {
            marker.delete();
            assertTrue("a reminder marker was already there", false);
        }
        marker.getParentFile().mkdirs();
        assertTrue(marker.createNewFile());
    }
}
