package com.example.orders;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

public class RatesClient {
    public int rate(String currency) throws IOException {
        try (InputStream in = new URL(System.getProperty("rates.url") + "/" + currency).openStream()) {
            return in.read();
        }
    }
}
