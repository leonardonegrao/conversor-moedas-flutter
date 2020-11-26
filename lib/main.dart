import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const requestUrl = 'https://api.hgbrasil.com/finance?key=4746fa7f';

void main() async {
  runApp(MaterialApp(
    home: Home(),
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
  double dolar;
  double euro;

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
                  dolar = snapshot.data['results']['currencies']['USD']['buy'];
                  euro = snapshot.data['results']['currencies']['EUR']['buy'];

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
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Reais',
                            labelStyle: TextStyle(
                              color: Colors.amber,
                            ),
                            border: OutlineInputBorder(),
                            prefixText: 'R\$ ',
                          ),
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25.0,
                          ),
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Dólares',
                            labelStyle: TextStyle(
                              color: Colors.amber,
                            ),
                            border: OutlineInputBorder(),
                            prefixText: 'R\$ ',
                          ),
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25.0,
                          ),
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Euros',
                            labelStyle: TextStyle(
                              color: Colors.amber,
                            ),
                            border: OutlineInputBorder(),
                            prefixText: '€ ',
                          ),
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }
            }
          },
        ));
  }
}
