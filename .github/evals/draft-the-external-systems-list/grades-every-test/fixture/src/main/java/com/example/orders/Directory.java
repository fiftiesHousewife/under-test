package com.example.orders;

import java.util.Hashtable;
import java.util.Properties;
import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.InitialDirContext;

public class Directory {
    private final Properties settings;

    public Directory(Properties settings) {
        this.settings = settings;
    }

    public boolean knows(String user) throws NamingException {
        Hashtable<String, String> env = new Hashtable<>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, settings.getProperty("ldap.url"));
        return new InitialDirContext(env).getAttributes("uid=" + user) != null;
    }
}
