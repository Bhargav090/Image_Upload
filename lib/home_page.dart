import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bhargav_pathivada/frame.dart';

enum AppState {
  free,
  picked,
  cropped,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppState state;
  File? imageFile;
  File? updatedImageFile; // to Store the updated image here(After the frame page shape one...)

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.grey[700],
            size: 40.0,
          ),
          onPressed: () {
             exit(0);
          },
        ),
        title: Center(
          child: Text(
            'Add Image / Icon',
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Column(
                    children: [
                      const Text(
                        'Upload Image',
                        style: TextStyle(fontSize: 19),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _pickImage();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal[800],
                          ),
                          child: const Text(
                            'Choose from Device',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (state == AppState.cropped && updatedImageFile != null) // Show the updated image
              Container(
                child: Image.file(
                  updatedImageFile!,
                  width: 150,
                  height: 150,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
      await _cropImage();
    } else {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<void> _cropImage() async {
    if (imageFile == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: imageFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
    );

    if (cropped != null) {
      setState(() {
        updatedImageFile = File(cropped.path); // to Update the updatedImageFile
        imageFile = updatedImageFile; // Update imageFile as well for both....
        state = AppState.cropped;
      });

      // to Show the FramePage as a dialog .....................
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop(); 
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Uploaded Image',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  FramePage(
                    imageFile: imageFile, 
                    onUpdateImage: (updatedImage) {
                     
                      setState(() {
                        updatedImageFile = updatedImage;
                      });

                    
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
