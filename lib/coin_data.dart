import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR',
  'EGP'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const apiKey = 'E62ACD81-44C9-4898-997C-A2B14922E050';
const coinApi = 'https://rest.coinapi.io/v1/exchangerate';
String requestURL = '$coinApi/BTC/?apikey=$apiKey';

class CoinData {
  Future<Map<String, String>> getCoinData(String? selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String requestURL = '$coinApi/$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(Uri.parse(requestURL));
      if (response.statusCode == 200) {
        print(response.body);
        var decodedData = jsonDecode(response.body);
        var lastPrice = decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
      }
    }
    return cryptoPrices;
  }
}
