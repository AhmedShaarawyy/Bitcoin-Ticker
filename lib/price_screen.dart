import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = "AUD";

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  //11. Create an async method here await the coin data from coin_data.dart
  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);

      isWaiting = false;

      //13. We can't await in a setState(). So you have to separate it out into two steps.
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //14. Call getData() when the screen loads up. We can't call CoinData().getCoinData() directly here because we can't make initState() async.
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(169, 6, 32, 95),
      appBar: AppBar(
        backgroundColor: Color(0xff102864),
        title: Text(' Coin Ticker'),
        leading: Icon(Icons.currency_bitcoin),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: [
              cryptoCard(
                  cryptoCurrency: 'BTC',
                  value: isWaiting ? '?' : coinValues['BTC'],
                  selectedCurrency: selectedCurrency,
                  image: Image.asset("images/bitcoin.png")),
              cryptoCard(
                cryptoCurrency: 'ETH',
                value: isWaiting ? '?' : coinValues['ETH'],
                selectedCurrency: selectedCurrency,
                image: Image.asset("images/currency.png"),
              ),
              cryptoCard(
                cryptoCurrency: 'LTC',
                value: isWaiting ? '?' : coinValues['LTC'],
                selectedCurrency: selectedCurrency,
                image: Image.asset("images/litecoin.png"),
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Color(0xff102864),
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          )
        ],
      ),
    );
  }
}

class cryptoCard extends StatelessWidget {
  const cryptoCard(
      {this.value,
      this.selectedCurrency,
      this.cryptoCurrency,
      required this.image});

  final String? value;
  final String? selectedCurrency;
  final String? cryptoCurrency;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Color(0xff102864),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Row(
            children: [
              Container(width: 30, height: 30, child: image),
              SizedBox(
                width: 10,
              ),
              Text(
                '1 $cryptoCurrency = $value $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
