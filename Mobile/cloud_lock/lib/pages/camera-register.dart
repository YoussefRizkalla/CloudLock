import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;


class CameraRegisterPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraRegisterPage({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  CameraRegisterPageState createState() => CameraRegisterPageState();
}

class CameraRegisterPageState extends State<CameraRegisterPage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<http.Response> postFirebase(String body) async {
    try {
      List<dynamic> json = jsonDecode(body);
      String faceId = json[0]['faceId'];
      Map<String, String> bodyToSend = new Map();
      bodyToSend['key'] = faceId;

      Map<String, String> headers = new Map();
      headers['Content-Type'] = 'application/json';

      Response response = await http.post('https://cloudlock-ca508.firebaseapp.com/putToFirebase', body: jsonEncode(bodyToSend), headers: headers);
      return response;
    } catch (e) {
      return new Response('Failed', 500);
    }
  }

  Future<http.Response> fetchPost(Uint8List image) async {
    try {
      Map<String, String> headers = new Map();
      headers['Ocp-Apim-Subscription-Key'] = 'b6a6d46bb48942be82431c12c5386f05';
      headers['Content-Type'] = 'application/octet-stream';
      return await http.post('https://cloudlock-face.cognitiveservices.azure.com/face/v1.0/detect', headers: headers, body: image);
    } catch (e) {
       return new Response('Failed', 500); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the 
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);
            Response res = await fetchPost(File(path).readAsBytesSync());
            await postFirebase(res.body);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuccessScreen()));

          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up Success!", style: TextStyle(fontSize: 32, fontFamily: 'IndieFlower')),),
      body: Container ( 
        child: Center (
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HomePicture(),
                Text('Enjoy safety and convenience at your fingertips'),
              ],
            ) 
        )
      )
    );
  }
}

class HomePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home.png'),
            fit: BoxFit.cover),
      ),
    );
  }
}