@isTest
global class ExchangeRateControllerMockFailure implements HttpCalloutMock {
  global HTTPResponse respond(HTTPRequest request) {
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody('{"error": {"code": "404", "message": "Not found"}}');
    response.setStatusCode(404);
    return response;
  }
}