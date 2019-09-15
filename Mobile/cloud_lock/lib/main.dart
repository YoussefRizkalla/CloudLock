import 'package:camera/camera.dart' show CameraDescription, availableCameras;
import 'package:cloud_lock/pages/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_plugin/models/nfc_event.dart';
import 'package:flutter_nfc_plugin/nfc_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Lock',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Cloud Lock'),
      
    );
  }
}

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/logo-circle.png'),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.all(Radius.circular(75.0)),
          boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.greenAccent)]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraDescription _camera;
  int _selectedIndex = 0;

  
  @override
  void initState() {
    super.initState();
    _loadNFC();
  }

  void _onItemTapped(int index) {
    setState(() async {
      _selectedIndex = index;
    });
  }

  Future setCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    _camera = cameras[1]; 
  }

  Future _loadNFC() async {
    NfcPlugin nfcPlugin = NfcPlugin();
    nfcPlugin.onNfcMessage.listen((NfcEvent event) async {
        await setCamera();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CameraPage(camera: _camera,)),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'IndieFlower'),)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.green[800],
              Colors.green[700],
              Colors.green[600],
              Colors.green[400],
            ],
          ),
        ),

        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProfilePicture(),
            Padding(padding: EdgeInsets.all(25),),
            Text(
              "Enable your phone's NFC to unlock your door",
              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text('Help'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[1000],
        onTap: _onItemTapped,
      ),
    );
  }
}
