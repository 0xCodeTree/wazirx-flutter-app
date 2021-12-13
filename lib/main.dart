import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var wzxPrice = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: PriceWidget(),
      ),
    );
  }
}

class PriceWidget extends StatefulWidget {
  @override
  _PriceWidgetState createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget> {
  var url = Uri.parse('https://api.wazirx.com/sapi/v1/tickers/24hr');

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 30), (_) => setState(() {}));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Crypto Price Data'),
        ),
        body: FutureBuilder(
            future: http.get(url),
            builder: (context, snapshot) {
              List<Widget> children;

              if (snapshot.hasData) {
                List prices = [];
                List prevPrices = [];
                http.Response response = snapshot.data as http.Response;
                print(response.statusCode);
                if (response.statusCode == 200) {
                  prices = jsonDecode(response.body);
                  prevPrices = prices;
                }
                children = [
                  ...prices
                      .map((asset) => Container(
                            padding: const EdgeInsets.only(top: 16),
                            child: response.statusCode == 200
                                ? ListTile(
                                    leading: Text(
                                        '${asset['baseAsset'].toUpperCase()}/INR'),
                                    trailing: Text(
                                      '${asset['lastPrice']}',
                                    ))
                                : Text('Data not recieved'),
                          ))
                      .toList(),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('${response.statusCode}'),
                  )
                ];
              } else if (snapshot.hasError) {
                children = [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }
              return Center(
                child: ListView(
                  children: children,
                ),
              );
            }));
  }
}
