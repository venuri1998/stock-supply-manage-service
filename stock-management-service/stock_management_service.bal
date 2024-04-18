import ballerina/http;
import ballerina/log;
import ballerina/sql;
import ballerinax/mysql.driver as _;

// Define the stock management service
service StockManagement /stocks on new http:Listener(8090) {

    public function init() returns error? {
        log:printInfo("stock management service started");
        error? initDatabaseResult = initDatabase();
        if initDatabaseResult is error {
            log:printError("Error creating stock table: ", initDatabaseResult);
        } // Initialize the database table
    }

    # Get all the items
    #
    # + return - The list of items or error message
    resource function get stocks() returns Stocks[]|error {
        stream<Stocks, sql:Error?> itemStream = stockDb->query(`SELECT * FROM stocks`);
        return from Stocks item in itemStream
            select item;
    }

    # Create a new item
    #
    # + newItem - The item details of the new item
    # + return - The created message or error message
    resource function post stocks(NewItem newItem) returns http:Created|error {
        _ = check stockDb->execute(`
            INSERT INTO stocks(name, category, cost_price, sale_price, quantity, created_at, updated_at)
            VALUES (${newItem.name}, ${newItem.category}, ${newItem.cost_price}, ${newItem.sale_price}, ${newItem.quantity}, CURDATE(), CURDATE());`);
        return http:CREATED;
    }
}

public function initDatabase() returns error? {
    error|sql:ExecutionResult result = check stockDb->execute(`CREATE TABLE IF NOT EXISTS stocks (
                                        id INT AUTO_INCREMENT PRIMARY KEY,
                                        name VARCHAR(255),
                                        category VARCHAR(255),
                                        cost_price DECIMAL(10, 2),
                                        sale_price DECIMAL(10, 2),
                                        quantity DECIMAL(10, 2),
                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
                                    );`);
    if (result is error) {
        log:printError("Error creating stock table: ", result);
    } else {
        log:printInfo("Stock table created successfully");
    }
}
