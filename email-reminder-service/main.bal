import ballerina/log;
import ballerina/sql;
import wso2/choreo.sendemail as ChoreoEmail;

// Define configurable variables
configurable string appointmentApiUrl = ?;
configurable string dbUrl = ?;
configurable string dbUsername = ?;
configurable string dbPassword = ?;

// Define record type for Superadmin
type Superadmin record {
    string email;
};

// Main function
public function main() returns error? {
    
    // Execute SQL query to get stock collection record count
    int stockCount = check getStockCount();

    // Get superadmins' emails
    Superadmin[] superadmins = check getSuperadmins();
   

    // Construct email content
    string emailContent = "Stock Collection Record Count: " + stockCount.toString() + "\n\n";
    emailContent = emailContent + "Superadmins:\n";
    foreach var admin in superadmins {
        emailContent = emailContent + admin.email + "\n";
    }

    // Send email
    check sendEmail(emailContent);
}

// Function to get stock collection record count
function getStockCount() returns int|sql:Error {
    // Execute SQL query to get stock collection record count
    int stockCount = 0;
    sql:ParameterizedQuery query = `SELECT COUNT(*) AS count FROM stocks`;
    stockCount = check stockDb->queryRow(query);
    return stockCount;
}

// Function to get superadmins' emails
function getSuperadmins() returns Superadmin[]|error {
    stream<Superadmin, sql:Error?> superadminStream = stockDb->query(`SELECT email FROM users WHERE role = 'superadmin'`);
    return from Superadmin admin in superadminStream
           select admin;
}


// Send Email function
function sendEmail(string content) returns error? {
    ChoreoEmail:Client emailClient = check new ();
    string sendEmailResponse = check emailClient->sendEmail("recipient@example.com", "Stock Record Count and Superadmins", content);
    log:printInfo("Email sent successfully with response: " + sendEmailResponse);
}
