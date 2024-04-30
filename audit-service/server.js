require('dotenv').config();

const express = require('express');
const bodyParser = require('body-parser');
const Audit = require('./auditModel'); // Import the model

const app = express();
const port = 8091; // You can choose any port that is free

app.use(bodyParser.json());

// Sync Sequelize models
Audit.sequelize.sync().then(() => {
    console.log(`Database & tables created!`);
});

// Booking endpoint
app.post('/audit', async (req, res) => {
    try {
        // Extract audit log data from the request body
        const { action, stockID, oldValue = null, newValue = null } = req.body;

        // Create a new audit log entry in the database
        const newAuditLog = await Audit.create({ action, stockID, oldValue, newValue });
        
        // Send a success response with the created audit log
        res.status(201).json(newAuditLog);
    } catch (error) {
        // Handle errors
        console.error('Error creating audit log:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});