package com.example.orders;

import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

public class Notifier {
    private final Properties settings;

    public Notifier(Properties settings) {
        this.settings = settings;
    }

    public void send(String message) throws IOException {
        try (Socket socket = new Socket(settings.getProperty("mail.smtp.host"), 25);
             OutputStream out = socket.getOutputStream()) {
            out.write(message.getBytes(StandardCharsets.UTF_8));
        }
    }
}
