import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_generator/utilities/utils.dart';
import 'package:printing/printing.dart';

import 'entities/page_item.dart';

class PdfApp extends StatefulWidget {
  const PdfApp({super.key});

  @override
  State<PdfApp> createState() => _PdfState();
}

class _PdfState extends State<PdfApp> {
  final TextEditingController inputPdf = TextEditingController();
  final TextEditingController titlePdf = TextEditingController();
  final List<PageItem> pageItems = <PageItem>[];
  late bool loading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: createMaterialColor(Color(0xFFF15A29))),
      home: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });
                    addNewPage();
                    setState(() {
                      loading = false;
                    });
                    exibirAlertaPersonalizado(context, 'Página Adicionada!',
                        'Sucesso ao adicionar a página no PDF.');
                  },
                  child: Icon(Icons.add_to_photos_rounded)),
            ),
            FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  if (pageItems.length > 0) {
                    setState(() {
                      loading = true;
                    });
                    generatePdf();
                    setState(() {
                      loading = false;
                    });

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return viewPdf();
                    }));
                  } else {
                    exibirAlertaPersonalizado(
                        context,
                        'Nenhuma página adicionada!',
                        'Adicione pelo menos 1 página antes de gerar o PDF.');
                  }
                },
                child: Icon(Icons.check))
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            !loading
                ? Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(children: [
                      // ignore: prefer_const_constructors
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            // ignore: prefer_const_constructors
                            child: Text(
                              'Easy PDF Generator ',
                              // ignore: prefer_const_constructorscd ..
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Icon(Icons.file_open),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: Color(0xFFF15A29),
                          width: 500,
                          height: 3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText:
                                          'Digite aqui o título da página.'),
                                  controller: titlePdf),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      border: OutlineInputBorder(),
                                      labelText:
                                          'Digite aqui o texto da página.'),
                                  maxLines: 30,
                                  maxLength: 3800,
                                  controller: inputPdf),
                            ),
                          ],
                        ),
                      )
                    ]),
                  )
                : const CircularProgressIndicator()
          ],
        )),
      ),
    );
  }

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    for (var item in pageItems) {
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(children: [
                pw.Text(item.title),
                pw.SizedBox(height: 15),
                pw.Text(item.text, textAlign: pw.TextAlign.justify),
              ]),
            );
          }));
    }
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

  void addNewPage() {
    PageItem newPageItem = PageItem();
    newPageItem.title = titlePdf.text;
    newPageItem.text = inputPdf.text;
    pageItems.add(newPageItem);
    titlePdf.text = '';
    inputPdf.text = '';
  }
}
