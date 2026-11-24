package com.example.orders;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

public class PriceClient {
    public int price(String sku) throws IOException {
        try (InputStream in = new URL("https://prices.acme.internal/prices/" + sku).openStream()) {
            return in.read();
        }
    }
}
