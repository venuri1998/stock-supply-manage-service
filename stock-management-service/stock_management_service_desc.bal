import ballerina/constraint;
import ballerina/http;
import ballerina/time;

type StockManagement service object {
    *http:Service;

    // stock resource
    resource function get stocks() returns Stocks[]|error;
    //resource function get stocks/[int id]() returns Stocks|ItemNotFound|error;
    resource function post stocks(NewItem newItem) returns http:Created|error;
    //resource function delete stocks/[int id]() returns http:NoContent|error;

};

// stock representations
type Stocks record {|
    int id;
    string name;
    string category;
    decimal cost_price;
    decimal sale_price;
    decimal quantity;
    time:Civil created_at;
    time:Civil updated_at;

|};

public type NewItem record {|
    @constraint:String {
        minLength: 2
    }
    string name;
    string category;
    float cost_price;
    float sale_price;
    float quantity;
|};

type ItemNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

type ErrorDetails record {|
    time:Utc timeStamp;
    string message;
    string details;
|};
