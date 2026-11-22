package com.example.orders;

import java.io.IOException;
import java.net.Socket;

public class Mailer {

    private final String host;

    public Mailer(String host) {
        this.host = host;
    }

    public void sendConfirmation(String orderNumber) throws IOException {
        try (Socket socket = new Socket(host, 25)) {
            socket.getOutputStream().write(("CONFIRM " + orderNumber + "\r\n").getBytes("US-ASCII"));
        }
    }
}
