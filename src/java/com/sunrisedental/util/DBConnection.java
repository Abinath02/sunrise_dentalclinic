package com.sunrisedental.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3307/sunrise_dental?allowPublicKeyRetrieval=true&useSSL=false";
    private static final String USER = "root";
    private static final String PASSWORD = ""; 

    public static Connection getConnection() throws SQLException {
        try {
            // New driver class for MySQL 8+
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("MySQL JDBC Driver not found!");
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
