@isTest
private class ExchangeRateControllerTest {
  @isTest
  static void testGetLastExchangeRateSuccess() {
    // Set up the mock HTTP callout
    Test.setMock(HttpCalloutMock.class, new ExchangeRateControllerMock());

    // Call the method being tested
    Decimal result = ExchangeRateController.getLastExchangeRate();

    // Verify the result
    Decimal expected = 5.2493;
    System.assertEquals(expected, result);
  }

  @isTest
  static void testGetLastExchangeRateFailure() {
    // Set up the mock HTTP callout
    Test.setMock(
      HttpCalloutMock.class,
      new ExchangeRateControllerMockFailure()
    );

    // Call the method being tested
    Decimal result = ExchangeRateController.getLastExchangeRate();

    // Verify the result
    System.assertEquals(null, result);
  }
}
