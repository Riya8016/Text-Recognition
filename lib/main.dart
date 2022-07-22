// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:intx/Core_screen.dart';

// import 'Core_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Homepage(),
//     );
//   }
// }

// class Homepage extends StatefulWidget {
//   const Homepage({Key key}) : super(key: key);

//   @override
//   _HomepageState createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   File image;
//   File imageFile;

//   String scannedText = "";
//   bool textScanning = false;

//   pickimage(ImageSource source) async {
//     try {
//       final ImagePicker _picker = ImagePicker();

//       final XFile image = await _picker.pickImage(source: source);
//       if (image != null) {
//         setState(() {
//           imageFile = File(image.path);
//         });
//       }
//     } on PlatformException catch (e) {
//       print('failed to pick image: $e');
//     }
//   }

//   getText(File image) async {
//     final inputImage = InputImage.fromFilePath(image.path);
//     final textDetector = GoogleMlKit.vision.textDetector();
//     RecognisedText recognisedText = await textDetector.processImage(inputImage);
//     await textDetector.close();
//     scannedText = "";
//     for (TextBlock block in recognisedText.blocks) {
//       for (TextLine line in block.lines) {
//         scannedText = scannedText + line.text + "\n";
//       }
//     }
//     textScanning = false;
//     Core_screen(display_text: scannedText);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Text Recogintion'),
//         backgroundColor: Colors.orange,
//       ),
//       body: imageFile != null
//           ? Container(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Image.file(
//                       imageFile,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       FloatingActionButton(
//                         onPressed: () {
//                           Homepage();
//                         },
//                         child: const Icon(Icons.arrow_back),
//                       ),
//                       FloatingActionButton(
//                         onPressed: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => getText(image),
//                           ));
//                         },
//                         child: const Icon(Icons.arrow_forward),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           : Container(
//               padding: EdgeInsets.all(25),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 48),
//                   ElevatedButton(
//                     onPressed: () {
//                       pickimage(ImageSource.gallery);
//                     },
//                     child: Text('Gallery'),
//                   ),
//                   ElevatedButton(
//                       onPressed: () {
//                         pickimage(ImageSource.camera);
//                       },
//                       child: Text('camera')),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// import 'package:intx/Core_screen.dart';
import 'Core_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File imageFile;
  String imagepath;

  String scannedText = "";
  bool textScanning = false;

  Future pickimage(ImageSource source) async {
    try {
      final ImagePicker _picker = ImagePicker();

      final XFile image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          imageFile = File(image.path);

          imagepath = imageFile.path;
        });
      }
    } on PlatformException catch (e) {
      print('failed to pick image: $e');
    }
  }

  getText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.processImage(inputImage);
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        // for (TextElement element in line.elements) {
        setState(() {
          scannedText = scannedText + ' ' + line.text;
          debugPrint(scannedText);
        });
        // }
        scannedText = scannedText + '\n';
      }
    }
    textScanning = false;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Core_screen(
                  display_text: scannedText,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recogintion'),
        backgroundColor: Colors.orange[600],
      ),
      body: imageFile != null
          ? Container(
              child: Column(
                children: [
                  Container(
                    height: 500,
                    width: 450,
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: () {
                          setState(() {
                            imageFile = null;
                          });
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      FloatingActionButton(
                        heroTag: "btn2",
                        onPressed: () {
                          getText(imagepath);
                        },
                        child: const Icon(Icons.arrow_forward),
                      )
                    ],
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.orange[600]),
                    onPressed: () {
                      pickimage(ImageSource.gallery);
                    },
                    icon: Icon(Icons.photo_album),
                    label: Text('From Gallery'),
                  ),
                  ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.orange[600]),
                      onPressed: () {
                        pickimage(ImageSource.camera);
                      },
                      icon: Icon(Icons.camera),
                      label: Text('From Camera')),
                ],
              ),
            ),
    );
  }
}

// class Core_screen extends StatefulWidget {
//   final String display_text;

//   const Core_screen({Key key, this.display_text}) : super(key: key);

//   @override
//   State<Core_screen> createState() => _Core_screenState();
// }

// class _Core_screenState extends State<Core_screen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recognized Text'),
//         backgroundColor: Colors.orange,
//       ),
//       body: SingleChildScrollView(
//         // Container(
//         child: Text('${widget.display_text}'),
//         // ),
//       ),
//     );
//   }
// }
