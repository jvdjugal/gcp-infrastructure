const express = require('express');
const { Pool } = require('pg');  // Assuming PostgreSQL
const app = express();
const port = 5000;

// Mock data for to-do list (if you don't have a database connected yet)
let todos = [];

// Database connection setup for Cloud SQL using the Unix socket
const pool = new Pool({
    user: 'your-db-username',      // Replace with your DB username
    host: '/cloudsql/dspl-24-poc:us-central1:my-instance', // Cloud SQL socket
    database: 'your-database',     // Replace with your database name
    password: 'your-db-password',  // Replace with your DB password
    port: 5432,                    // Default PostgreSQL port
  });
  

app.use(express.json());

// API to get the list of todos (fetch from the database)
app.get('/todos', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM todos');
    res.json(result.rows);  // Assuming the todos table has a "todo" column
  } catch (err) {
    console.error('Error fetching todos:', err);
    res.status(500).send('Error fetching todos');
  }
});

// API to add a new to-do item (insert into the database)
app.post('/todos', async (req, res) => {
  const newTodo = req.body.todo;
  try {
    await pool.query('INSERT INTO todos (todo) VALUES ($1)', [newTodo]);
    res.status(201).send('Todo added');
  } catch (err) {
    console.error('Error adding todo:', err);
    res.status(500).send('Error adding todo');
  }
});

app.listen(port, () => {
  console.log(`Backend app listening at http://localhost:${port}`);
});
