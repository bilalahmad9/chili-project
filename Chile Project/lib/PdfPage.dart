//IMPORTACIONES DE TERCEROS

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:postapp/AdminPage.dart';
import 'package:postapp/util/menu.dart';
//import 'package:flutter_share/flutter_share.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import 'authentication/bloc/authentication_bloc.dart';

class PdfPage extends StatefulWidget {
  //AdminPage({Key key}) : super(key:  key);
  PdfPage({this.username, this.token});
  final String username;
  final String token;

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  bool _isLoading = true;
  PDFDocument document;
  int _counter = 0;

  void _loadPdf() async {
    document = await PDFDocument.fromURL(
        "https://si.ua.es/es/documentos/documentacion/pdf-s/mozilla12-pdf.pdf");
    setState(() {
      _isLoading = false;
    });
  }

/*  _launchURL() async {
    const url = 'https://si.ua.es/es/documentos/documentacion/pdf-s/mozilla12-pdf.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  Future<void> share() async {
    await FlutterShare.share(
        title: 'PDF File share',
        //text: 'Example share text',
        linkUrl: _launchURL(),
        chooserTitle: 'My PDF File');
  }*/

  String text = 'https://si.ua.es/es/documentos/documentacion/pdf-s/mozilla12-pdf.pdf';
  String subject = 'PDF Book';

  //String url;

  @override
  void initState() {
    super.initState();
    // _tokensito();
    _loadPdf();
  }

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFFfccf03);
    return MaterialApp(
      title: 'Pantalla 2 Indicadores Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        drawer: MenuLateral(),
        appBar: AppBar(
           backgroundColor: PrimaryColor,
          title: Text('Pantalla 2 Indicadores Admin',style: TextStyle(
    color: Colors.black
  )),
        ),
        body: Center(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    children: [
                      PDFViewer(
                        document: document,
                        showPicker: false,
                        showNavigation: false,
                        showIndicator: false,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Center(
                              child: _crearBotones(),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20, bottom: 50),
                                child: FloatingActionButton(
                                  child: Icon(Icons.share),
                                  elevation: 5,
                                  onPressed: ()
                                  {
                                    final RenderBox box = context.findRenderObject();
                                    Share.share(text,
                                        subject: subject,
                                        sharePositionOrigin:
                                        box.localToGlobal(Offset.zero) &
                                        box.size);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
      ),
    );
  }

  //creamos los botones
  Widget _crearBotones() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text("Cerrar Sesion"),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(PushLoginPage());
            },
          ),
          RaisedButton(
            child: Text("Volver"),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(PushAdminPage());
            },
          ),
          /*Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: FloatingActionButton(
                  child: Icon(Icons.share),
                  elevation: 5,
                  onPressed: _launchURL,
                ),
              ),
            ],
          ),*/
          // Text(msg,style: TextStyle(fontSize: 20.0,color: Colors.red),),
          // Text('   Hola $username, tu token guardado en app $token', style: TextStyle(fontSize: 15.0),),
        ],
      ),
    );
  }
}
