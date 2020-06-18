// import ballerina/http;
// import ballerina/time;
// import ballerina/observe;
// import ballerina/io;

// http:Client clientEndpoint = new("http://dummy.restapiexample.com/api/v1");

// public function main() {
//     io:println("GET request:");
//     var response = clientEndpoint->get("/employees");
//     handleResponse(response);

//     io:println("POST request:");
//     response = clientEndpoint->post("/create", {"name":"test","salary":"123","age":"23"});
//     handleResponse(response);

//     string currentTime = getCurrentTime();
//     io:println(io:sprintf("Current Time: %s", currentTime));
// }

// @observe:Observable
// public function getCurrentTime() returns string {
//     time:Time time = time:currentTime();
//     return time:toString(time);
// }

// function handleResponse(http:Response|error response) {
//     if (response is http:Response) {
//         var msg = response.getJsonPayload();
//         if (msg is json) {

//             io:println(msg.toJsonString());
//         } else {
//             io:println("Invalid payload received: " , msg.reason());
//         }
//     } else {
//         io:println("Error when calling the backend: ", response.reason());
//     }
// }
