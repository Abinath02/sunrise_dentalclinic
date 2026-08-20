package com.sunrisedental.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3307/sunrise_dental?allowPublicKeyRetrieval=true&useSSL=false";
    private static final String USER = "root";
    private static final String PASSWORD = ""; 

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
            // Log and Fallback to direct connection if JNDI is not configured
            System.out.println("JNDI DataSource not found, falling back to direct connection: " + e.getMessage());
        }

        try {
            // New driver class for MySQL 8+
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("MySQL JDBC Driver not found!");
        }
    }
}
