import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_lock/pages/camera-register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_plugin/models/nfc_event.dart';
import 'package:flutter_nfc_plugin/nfc_plugin.dart';
  
class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  CameraDescription _camera;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    _loadNFC();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
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
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraRegisterPage(camera: _camera,)));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(fontSize: 32, fontFamily: 'IndieFlower'),),
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
              "Scan your assigned NFC card to register your face",
              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      ),
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
                  'assets/shield.png'),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.all(Radius.circular(75.0)),
          boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.greenAccent)]),
    );
  }
}

