import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.last;

  runApp(
    MaterialApp(
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

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
        appBar: AppBar(
          title: Center(
            child: Text('Yoga Instructor App',style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          backgroundColor: Color(0xFFb149e6),
        ),
        body: Column(
          children: [
            // Expanded(
            //   flex: 5,
            //   child:
            Container(
              color: Colors.red,
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(_controller);
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              // ),
            ),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/pose1.jpg',height: 160.0,),
                  Transform.rotate(angle: -pi/2,
                      child: Text('Padmasan',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFFb149e6)),),),
                  // SizedBox(width:2.0,),
                  Container(color: Color(0xFFb149e6),child: null,height: double.infinity,width: 10.0,),
                  Padding(
                    // padding: const EdgeInsets.only(top: 70.0),
                    padding: EdgeInsets.symmetric(vertical: 50.0),
                    child: Transform.rotate(angle: -pi/2,child :
                    Column(

                      children: [
                        Text('Time Left',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Color(0xFFb149e6),),),
                        Row(
                          children: [
                            Text('12',style: TextStyle(fontSize: 60.0,fontWeight: FontWeight.bold),),
                            Text('s',style: TextStyle(fontSize: 40.0,fontWeight: FontWeight.w300),),
                          ],
                        )
                      ],
                    ),),
                  ),
                  // Transform.rotate(angle: -pi/2,child: Center(child: Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: ,
                  // )))
                ],
              )
            ),
          ],
        )
        // body: FutureBuilder<void>(
        //   future: _initializeControllerFuture,
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       // If the Future is complete, display the preview.
        //       return CameraPreview(_controller);
        //     } else {
        //       // Otherwise, display a loading indicator.
        //       return const Center(child: CircularProgressIndicator());
        //     }
        //   },
        // ),
        // floatingActionButton: FloatingActionButton(
        //   // Provide an onPressed callback.
        //   onPressed: () async {
        //     // Take the Picture in a try / catch block. If anything goes wrong,
        //     // catch the error.
        //     try {
        //       // Ensure that the camera is initialized.
        //       await _initializeControllerFuture;
        //
        //       // Attempt to take a picture and get the file `image`
        //       // where it was saved.
        //       final image = await _controller.takePicture();
        //
        //       // If the picture was taken, display it on a new screen.
        //       await Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (context) => DisplayPictureScreen(
        //             // Pass the automatically generated path to
        //             // the DisplayPictureScreen widget.
        //             imagePath: image.path,
        //           ),
        //         ),
        //       );
        //     } catch (e) {
        //       // If an error occurs, log the error to the console.
        //       print(e);
        //     }
        //   },
        //   child: const Icon(Icons.camera_alt),
        // ),
        );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
