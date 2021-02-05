import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=70f214e9";

void main() async {
  print(await getData());

  runApp(MaterialApp(
    home: HomePage(),
  ));
}

Future<Map> getData() async {
  http.Response resposta = await http.get(request);
  return json.decode(resposta.body);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final realcontroler = TextEditingController();
  final dolarcontroler = TextEditingController();
  final eurocontroler = TextEditingController();
  final renminbicontroler = TextEditingController();
  final bitcoincontroler = TextEditingController();

  double dolar;
  double euro;
  double reais;
  double renminbi;
  double bitcoin;

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarcontroler.text = (real / dolar).toStringAsFixed(2);
    eurocontroler.text = (real / euro).toStringAsFixed(2);
    renminbicontroler.text = (real / renminbi).toStringAsFixed(2);
    bitcoincontroler.text = (real / bitcoin).toStringAsFixed(7);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realcontroler.text = (dolar = dolar * this.dolar).toStringAsFixed(2);
    eurocontroler.text = (dolar / euro).toStringAsFixed(2);
    renminbicontroler.text = (dolar / renminbi).toStringAsFixed(2);
    bitcoincontroler.text = (dolar / bitcoin).toStringAsFixed(7);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realcontroler.text = (euro = euro * this.euro).toStringAsFixed(2);
    dolarcontroler.text = (euro / dolar).toStringAsFixed(2);
    renminbicontroler.text = (euro / renminbi).toStringAsFixed(2);
    bitcoincontroler.text = (euro / bitcoin).toStringAsFixed(7);
  }

  void _renminbiChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double renminbi = double.parse(text);
    realcontroler.text =
        (renminbi = renminbi * this.renminbi).toStringAsFixed(2);
    eurocontroler.text = (renminbi / euro).toStringAsFixed(2);
    dolarcontroler.text = (renminbi / dolar).toStringAsFixed(2);
    bitcoincontroler.text = (renminbi / bitcoin).toStringAsFixed(7);
  }

  void _bitcoinChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double bitcoin = double.parse(text);
    realcontroler.text = (bitcoin = bitcoin * this.bitcoin).toStringAsFixed(2);
    dolarcontroler.text = (bitcoin / dolar).toStringAsFixed(2);
    renminbicontroler.text = (bitcoin / renminbi).toStringAsFixed(2);
    eurocontroler.text = (bitcoin / euro).toStringAsFixed(2);
  }

  void _clearAll() {
    realcontroler.text = "";
    dolarcontroler.text = "";
    eurocontroler.text = "";
    renminbicontroler.text = "";
    bitcoincontroler.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '\$ Conversor \$',
            style: TextStyle(color: Color(0xFF00BA83)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF36363F),
        ),
        backgroundColor: Color(0xFF41424F),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Carregando dados...",
                    style: TextStyle(color: Color(0xFF00F1BD), fontSize: 25),
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao Carregar Dados :(",
                      style:
                          TextStyle(color: Color(0xFF00F1BD), fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    renminbi =
                        snapshot.data["results"]["currencies"]["CNY"]["buy"];
                    bitcoin =
                        snapshot.data["results"]["currencies"]["BTC"]["buy"];

                    return Scaffold(
                        backgroundColor: Color(0xFF41424F),
                        body: SingleChildScrollView(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Icon(
                                Icons.monetization_on,
                                size: 150,
                                color: Color(0xFF00BA83),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Divider(),
                              buildTextField(
                                  "Reais", "R\$ ", realcontroler, _realChanged),
                              Divider(),
                              buildTextField("Dolar", "USD ", dolarcontroler,
                                  _dolarChanged),
                              Divider(),
                              buildTextField(
                                  "Euros", "EUR ", eurocontroler, _euroChanged),
                              Divider(),
                              buildTextField("Renminbi", "CNY ",
                                  renminbicontroler, _renminbiChanged),
                              Divider(),
                              buildTextField("Bitcoin", "BTC ",
                                  bitcoincontroler, _bitcoinChanged),
                            ],
                          ),
                        ),
                        floatingActionButton: FloatingActionButton(
                            child: Icon(
                              Icons.cleaning_services_rounded,
                              color: Color(0xFF41424F),
                            ),
                            backgroundColor: Color(0xFF00F1BD),
                            onPressed: _clearAll));
                  }
              }
            }));
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function function) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00BA83)),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00BA83)),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        prefixText: prefix,
        prefixStyle: TextStyle(color: Color(0xFF00F1BD), fontSize: 20),
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF00F1BD), fontSize: 20)),
    style: TextStyle(color: Color(0xFF00F1BD), fontSize: 20),
    onChanged: function,
  );
}
