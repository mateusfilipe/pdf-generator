import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfApp extends StatefulWidget {
  const PdfApp({super.key});

  @override
  State<PdfApp> createState() => _PdfState();
}

class _PdfState extends State<PdfApp> {
  final TextEditingController inputPdf = TextEditingController();
  final TextEditingController titlePdf = TextEditingController();

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String? pdfPath = '';

  Future<Uint8List> generatePdf() async {
    var textPdf = inputPdf.text;
    var title = titlePdf.text;
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(children: [
              pw.Text(title),
              pw.SizedBox(height: 15),
              pw.Text(textPdf, textAlign: pw.TextAlign.justify),
            ]),
          );
        }));
    // ignore: unused_local_variable
    return await pdf.save();
  }

  PdfPreview viewPdf() {
    return PdfPreview(
        allowSharing: false,
        canDebug: false,
        canChangePageFormat: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.arrow_back_ios_new))
        ],
        build: (format) => generatePdf());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(children: [
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  // ignore: prefer_const_constructors
                  child: Text(
                    'PDF Generator',
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    color: Color.fromARGB(255, 170, 1, 1),
                    width: 500,
                    height: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Digite aqui o texto para o pdf.'),
                          controller: titlePdf),
                      const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 5),
                        child: Text(
                          'Digite abaixo o texto para o PDF',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      TextFormField(
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 30,
                          maxLength: 3800,
                          controller: inputPdf),
                      TextButton(
                          onPressed: () {
                            generatePdf();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return viewPdf();
                            }));
                          },
                          child: const Text(
                            'Gerar PDF',
                            style: TextStyle(color: Color(0xFF004A65)),
                          )),
                    ],
                  ),
                )
              ]),
            )
          ],
        )),
      ),
    );
  }
}
