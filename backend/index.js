const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Database connection
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Test database connection
pool.getConnection((err, connection) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Successfully connected to database');
  connection.release();
});

// Routes
app.post('/api/users', async (req, res) => {
  const { country_name, country_code, phone_number } = req.body;

  try {
    // Check if phone number exists
    const [existingUsers] = await pool.promise().execute(
      'SELECT * FROM users WHERE phone_number = ?',
      [phone_number]
    );

    if (existingUsers.length > 0) {
      // User exists, return success with existing user data
      res.status(200).json({
        message: 'Login successful',
        user: existingUsers[0]
      });
      return;
    }

    // Create new user
    const [result] = await pool.promise().execute(
      'INSERT INTO users (country_name, country_code, phone_number) VALUES (?, ?, ?)',
      [country_name, country_code, phone_number]
    );

    // Get the newly created user
    const [newUser] = await pool.promise().execute(
      'SELECT * FROM users WHERE id = ?',
      [result.insertId]
    );

    res.status(201).json({
      message: 'User registered successfully',
      user: newUser[0]
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({
      error: 'Failed to process request'
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});