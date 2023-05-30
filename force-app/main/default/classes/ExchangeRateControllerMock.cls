@isTest
global class ExchangeRateControllerMock implements HttpCalloutMock {
  global HTTPResponse respond(HTTPRequest request) {
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody(
      '{"value": [{"cotacaoCompra": 5.2493, "cotacaoVenda": 5.2499}]}'
    );
    response.setStatusCode(200);
    return response;
  }
}
