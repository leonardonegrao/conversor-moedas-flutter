import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const requestUrl = 'https://api.hgbrasil.com/finance?key=4746fa7f';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        hintStyle: TextStyle(
          color: Colors.amber,
        ),
      ),
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(requestUrl);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final brlController = TextEditingController();
  final usdController = TextEditingController();
  final eurController = TextEditingController();

  double usd;
  double eur;

  void _brlOnChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double brl = double.parse(text);
    usdController.text = (brl / usd).toStringAsFixed(2);
    eurController.text = (brl / eur).toStringAsFixed(2);
  }

  void _usdOnChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double usd = double.parse(text);
    brlController.text = (usd * this.usd).toStringAsFixed(2);
    eurController.text = (usd / eur).toStringAsFixed(2);
  }

  void _eurOnChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double eur = double.parse(text);
    brlController.text = (eur * this.eur).toStringAsFixed(2);
    eurController.text = (eur + this.eur / usd).toStringAsFixed(2);
  }

  void _clearAll() {
    brlController.text = "";
    usdController.text = "";
    eurController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          title: Text('\$ Conversor de Moedas'),
          backgroundColor: Colors.amber,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text('Carregando dados...',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0,
                      )),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar dados',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        )),
                  );
                } else {
                  usd = snapshot.data['results']['currencies']['USD']['buy'];
                  eur = snapshot.data['results']['currencies']['EUR']['buy'];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150.0,
                          color: Colors.amber,
                        ),
                        buildTextField(
                            'Reais', 'R\$ ', brlController, _brlOnChange),
                        Divider(),
                        buildTextField(
                            'Dólares', '\$ ', usdController, _usdOnChange),
                        Divider(),
                        buildTextField(
                            'Euros', '€ ', eurController, _eurOnChange),
                      ],
                    ),
                  );
                }
            }
          },
        ));
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController editingController, Function onChange) {
  return TextField(
    controller: editingController,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.amber,
      ),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25.0,
    ),
    onChanged: onChange,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
