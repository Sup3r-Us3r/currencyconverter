import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=7f53fc54';

void main() {
  runApp(MaterialApp(
    title: 'Currency Converter',
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> _request() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('\$ Conversor \$'),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        backgroundColor: Colors.black,
        body: FutureBuilder<Map>(
          future: _request(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    'Carregando...',
                    style: TextStyle(color: Colors.amber, fontSize: 23),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar dados',
                      style: TextStyle(color: Colors.amber, fontSize: 23),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data['results']['currencies']['USD']['buy'];
                  euro = snapshot.data['results']['currencies']['EUR']['buy'];

                  return SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 150,
                            color: Colors.amber,
                          ),
                          Divider(
                            height: 40,
                            color: Colors.transparent,
                          ),
                          buildTextField(
                              'Reais', 'R\$', realController, _realChanged),
                          Divider(color: Colors.transparent),
                          buildTextField(
                              'Dólares', 'USD', dolarController, _dolarChanged),
                          Divider(color: Colors.transparent),
                          buildTextField(
                              'Euros', '€', euroController, _euroChanged)
                        ],
                      ));
                }
            }
          },
        ));
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function onChanged) {
  return TextField(
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: prefix,
      prefixText: prefix + ' ',
      labelStyle: TextStyle(color: Colors.amber, fontSize: 18),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber),
      ),
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 18,
    ),
    controller: controller,
    onChanged: onChanged,
  );
}
