package com.example.orders;

import org.junit.Test;

public class MailerTest {

    @Test
    public void sendsAConfirmation() throws Exception {
        new Mailer("mail.orders.invalid").sendConfirmation("LDN-000042");
    }
}
