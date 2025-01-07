# backend/app.py
from flask import Flask, jsonify
from flask_cors import CORS
import mysql.connector
import os

app = Flask(__name__)
CORS(app)

# Database configuration
db_config = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER', 'dbuser'),
    'password': os.getenv('DB_PASSWORD', ''),
    'database': os.getenv('DB_NAME', 'mydb')
}

@app.route('/api/health')
def health():
    return jsonify({"status": "healthy"})

@app.route('/api/data')
def get_data():
    try:
        # Connect to the database
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        
        # Execute a simple query
        cursor.execute("SELECT * FROM sample_data LIMIT 10")
        data = cursor.fetchall()
        
        cursor.close()
        conn.close()
        
        return jsonify({"data": data})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
