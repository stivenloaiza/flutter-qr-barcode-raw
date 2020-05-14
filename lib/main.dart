import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR - BARCODE - RAW',
      theme: new ThemeData(
          primaryColor: Color(0xffe1a93d),
          primaryTextTheme: TextTheme(
              title: TextStyle(
                  color: Colors.white
              )
          )
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String codeScaneado="";
  String tipoCode='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
          title: Text('QR - BARCODE - RAW',  style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white,),
        ),*/
        body:
        SafeArea(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width*0.50,
                        child: Image.asset('assets/images/logo-gimp-qr.png')),
                    SizedBox(height: 10,),
                    if(codeScaneado=='')Expanded(child: Container(),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        botonScan(),
                        if(codeScaneado!='')botonLimpiar(),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Expanded(child: ListView(
                      children: <Widget>[
                        Container(
                          child: codeScaneado!=''?Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('·RESULTADO:'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectableText(
                                      codeScaneado,
                                      showCursor: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('·TIPO: $tipoCode'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('·CARACTERES: ${codeScaneado.length}'),
                                  ),
                                ],
                              )):SizedBox(),
                        ),
                      ],
                    ),),
                    Text('·Desarrollado por: Stiven Loaiza\n·Contacto: loaizadeveloper@gmail.com', style: TextStyle(color: Colors.grey, fontSize: 10),textAlign: TextAlign.center,)
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget botonScan(){
    return GestureDetector(
      onTap: (){
        scanCode();
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: new BoxDecoration(
          color: Color(0xffe1a93d),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(FontAwesomeIcons.qrcode, color: Colors.white, size: 20,),
              SizedBox(height: 10,),
              Text(
                  'ESCANEAR',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)
              ),
            ],
          ),
        ),

      ),
    );
  }

  Widget botonLimpiar(){
    return GestureDetector(
      onTap: (){
        codeScaneado='';
        tipoCode='';
        setState(() {});
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: new BoxDecoration(
          color: Color(0xffe1a93d),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(FontAwesomeIcons.trash, color: Colors.white, size: 20,),
              SizedBox(height: 10,),
              Text(
                  'LIMPIAR',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)
              ),
            ],
          ),
        ),

      ),
    );
  }

  //Funciones
  //Escaneo del QR
  void scanCode() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();

      codeScaneado = barcode.rawContent;
      tipoCode=barcode.format.toString().toUpperCase();
      print(barcode.format);
      print('Note ${barcode.format}');
      setState(() {});
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          codeScaneado = 'No hay permisos!';
        });
      } else {
        setState(() => codeScaneado = 'Ocurrio un error: $e');
      }
    } on FormatException {
      setState(() {});
    } catch (e) {
      setState(() => codeScaneado = 'Ocurrio un error: $e');
    }
  }

}