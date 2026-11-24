package com.example.orders;

import static org.junit.Assert.assertTrue;

import java.util.Properties;
import org.junit.Rule;
import org.junit.Test;
import org.zapodot.junit.ldap.EmbeddedLdapRule;
import org.zapodot.junit.ldap.EmbeddedLdapRuleBuilder;

public class DirectoryTest {
    @Rule
    public EmbeddedLdapRule ldap = EmbeddedLdapRuleBuilder.newInstance().bindingToPort(12345).build();

    @Test
    public void findsAUser() throws Exception {
        Properties settings = new Properties();
        settings.setProperty("ldap.url", "ldap://localhost:12345");
        assertTrue(new Directory(settings).knows("ada"));
    }
}
