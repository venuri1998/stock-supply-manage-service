const { DataTypes } = require('sequelize');
const sequelize = require('./database');

const Audit = sequelize.define('Audit', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    timestamp: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    },
    userID: {
        type: DataTypes.INTEGER,
        allowNull: true // Allow null if operation is performed anonymously
    },
    action: {
        type: DataTypes.ENUM('CREATE', 'READ', 'UPDATE', 'DELETE'),
        allowNull: false
    },
    stockID: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    oldValue: {
        type: DataTypes.TEXT, // Adjust data type based on the length of stock data
        allowNull: true // Allow null for actions other than UPDATE or DELETE
    },
    newValue: {
        type: DataTypes.TEXT, // Adjust data type based on the length of stock data
        allowNull: true // Allow null for actions other than CREATE or UPDATE
    }
}, {
    tableName: 'Audit', // Optional: specify custom table name
    timestamps: false // Optional: disable timestamps (createdAt, updatedAt)
});

module.exports = Audit;
