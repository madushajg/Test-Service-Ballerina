import ballerina/http;
import ballerina/log;
import ballerina/observe;
import ballerina/io;
import ballerina/time;

http:Client clientEndpoint = new("http://postman-echo.com",
    {
        cache: {
            enabled: false
        }
    }
);

http:Client clientEndpoint2 = new("http://dummy.restapiexample.com/api/v1");

service sampleServiceNew on new http:Listener(10010) {

    resource function sayHello(http:Caller caller, http:Request req) {
        map<string[]> queryParams = req.getQueryParams();
        string name = queryParams.hasKey("name") ? queryParams.get("name")[0] : "World";

        var response = clientEndpoint->get("/get?test=999");
        handleResponse(response);

        http:Response res = new;
        if (name == "ok") {
            res.statusCode = http:STATUS_OK;
        } else if (name == "serverError") {
            res.statusCode = http:STATUS_INTERNAL_SERVER_ERROR;
        } else if (name == "userError"){
            res.statusCode = http:STATUS_NOT_FOUND;
        } else {
            var x = observe:addTagToSpan("error", "true");
            res.statusCode = http:STATUS_TEMPORARY_REDIRECT;
        }
        res.setTextPayload(io:sprintf("Hello sample, %s!!", name));
        var result = caller->respond(res);

        if (result is error) {
            log:printError("Error sending response", result);
        }
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "currentTime"
    }
    resource function findTime(http:Caller caller, http:Request req) {
        var result = caller->respond(getCurrentTime());

        if (result is error) {
            log:printError("Error sending response", result);
        }
    }

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/addEmployee"
    }
    resource function echoName(http:Caller caller, http:Request req) {
        var payload = req.getJsonPayload();
        http:Response res = new;
        if (payload is json) {
            log:printInfo("Received a json payload with POST request");
            string name = <string>payload.name;
            var response = clientEndpoint2->post("/create", <@untainted>{"name":name,"salary":"123","age":"23"});
            handleResponse(response);
            res.setTextPayload(<@untainted>io:sprintf("Successfuly added the employee %s to the system.", name));
        } else {
            res.statusCode = 500;
            res.setPayload(<@untainted> <string>payload.message());
        }

        var result = caller->respond(res);
        if (result is error) {
           log:printError("Error in responding", result);
        }
    }
}

// @observe:Observable
public function getCurrentTime() returns string {
    time:Time time = time:currentTime();
    return time:toString(time);
}

function handleResponse(http:Response|error response) {
    if (response is http:Response) {
        var msg = response.getJsonPayload();
        if (msg is json) {

            io:println(msg.toJsonString());
        } else {
            io:println("Invalid payload received: " , msg.message());
        }
    } else {
        io:println("Error when calling the backend: ", response.message());
    }
}
