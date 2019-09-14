import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

// A screen that allows users to take a picture using a given camera.
class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraPage({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
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

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  Future<http.Response> fetchPost(Uint8List image) async {
    Map<String, String> headers = new Map();
    headers['Ocp-Apim-Subscription-Key'] = 'b6a6d46bb48942be82431c12c5386f05';
    headers['Content-Type'] = 'application/octet-stream';
    print(headers);
    return await http.post('https://cloudlock-face.cognitiveservices.azure.com/face/v1.0/detect', headers: headers, body: image);
  }

    Future<http.Response> verify(Uint8List image) async {
    Map<String, String> headers = new Map();
    headers['Ocp-Apim-Subscription-Key'] = 'b6a6d46bb48942be82431c12c5386f05';
    headers['Content-Type'] = 'application/octet-stream';

    Response response = await http.post('https://cloudlock-face.cognitiveservices.azure.com/face/v1.0/detect', headers: headers, body: image);
    String face1 = '64e98c7e-eb59-4cc0-9b8d-b62d8d30d0d1';
    List<dynamic> json = jsonDecode(response.body);
    String face2 = json[0]['faceId'];

    Map<String, String> body = new Map();
    body['faceId1'] = face1;
    body['faceId2'] = face2;
        headers['Content-Type'] = 'application/json';

    return await http.post('https://cloudlock-face.cognitiveservices.azure.com/face/v1.0/verify', headers: headers, body: jsonEncode(body));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
      floatingActionButton: FloatingActionButton(onPressed: () async { 
        Response response = await verify(File(imagePath).readAsBytesSync());
        print(response.body);
      }),
    );
  }
}