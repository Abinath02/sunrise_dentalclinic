package com.sunrisedental.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    private static String URL;
    private static String USER;
    private static String PASSWORD;

    static {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                LOGGER.log(Level.WARNING, "Sorry, unable to find db.properties. Make sure it is in the classpath.");
            } else {
                prop.load(input);
                URL = prop.getProperty("db.url");
                USER = prop.getProperty("db.user");
                PASSWORD = prop.getProperty("db.password");
            }
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error loading database properties", ex);
        }
    }

    public static Connection getConnection() throws SQLException {
        // Try JNDI Connection Pooling first (Recommended for high traffic)
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            DataSource ds = (DataSource) envContext.lookup("jdbc/SunriseDentalDB");
            if (ds != null) {
                return ds.getConnection();
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "JNDI DataSource not found, falling back to direct connection: " + e.getMessage());
        }

        try {
            // New driver class for MySQL 8+
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found!", e);
            throw new SQLException("MySQL JDBC Driver not found!");
        }
    }
}
