/**
 * Classe responsável por realizar uma chamada para a API do Banco Central do Brasil
 * e retornar a cotação de compra do dólar americano em relação ao real para a data atual ou a última sexta-feira.
 */
public with sharing class ExchangeRateController {
  /**
   * Método que pega o dia atual e volta para a última sexta-feira, caso seja um final de semana.
   * @return Uma string com uma data válida para consumo da API no formato "MM-dd-yyyy"
   */
  public static String updateDateTime() {
    BusinessHours bh = [SELECT Id FROM BusinessHours WHERE name = 'Bacen'];
    System.debug('bh: ' + bh);

    DateTime now = DateTime.now();

    Boolean isBusinessHours = BusinessHours.isWithin(bh.id, now);
    System.debug('isBusinessHours: ' + isBusinessHours);

    String formatednow = now.format('E'); // Formata o dia no padrção de três letras. Ex "mon".
    // Caso o dia seja Sábado ou Domingo, remove dias para que volte para Sexta-feira

    if (!isBusinessHours) {
      now = now.addDays(-1);
    }

    if (formatednow == 'Sat') {
      now = now.addDays(-1);
    } else if (formatednow == 'Sun') {
      now = now.addDays(-2);
    }
    String validDate = now.format('MM-dd-yyyy');
    System.debug('##### now: ' + now);
    return validDate;
  }

  /**
   * Método que retorna a PTAX definida pelo Banco Central do Brasil (BACEN)
   * @return O valor da PTAX
   */
  @AuraEnabled(cacheable=true)
  public static Decimal getLastExchangeRate() {
    String validDate = updateDateTime();

    // Monta a URL de chamada para a API usando a data retornada pela função `updateDateTime`
    String endpoint =
      'https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)?@dataCotacao=\'' +
      validDate +
      '\'&$top=1&$format=json';
    System.debug('##### endpoint: ' + endpoint);

    // Realiza a chamada para a API do Banco Central do Brasil
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(endpoint);
    request.setMethod('GET');
    HttpResponse response = http.send(request);

    // Verifica se a chamada para a API do BACEN foi bem sucedida
    if (response.getStatusCode() == 200) {
      System.debug('#### response: ' + response);
      Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
        response.getBody()
      );
      System.debug('#### results : ' + responseMap);
      List<Object> values = (List<Object>) responseMap.get('value');
      System.debug('#### value : ' + values);
      Map<String, Object> firstValue = (Map<String, Object>) ((List<Object>) values)
        .get(0);
      // Map<String, Object> firstValue = (Map<String, Object>) values.get(0);
      Decimal ptax = Decimal.valueOf((Double) firstValue.get('cotacaoCompra'));
      System.debug('#### ptax : ' + ptax);
      return ptax;
    } else {
      return null;
    }
  }
}
