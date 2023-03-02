import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;
  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

void exibirAlertaPersonalizado(
    BuildContext context, String titulo, String mensagem) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(mensagem),
            ],
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                    color: Color(0xFFF15A29),
                    border: Border.all(color: Color(0xFFF15A29)),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: const Text(
                        'Fechar',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
            ),
          ),
        ],
      );
    },
  );
}
