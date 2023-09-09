import 'dart:io';
import 'package:flutter/material.dart';

class FramePage extends StatefulWidget {
  final File? imageFile;
  final Function(File)? onUpdateImage;

  FramePage({Key? key, this.imageFile, this.onUpdateImage}) : super(key: key);

  @override
  _FramePageState createState() => _FramePageState();
}

class _FramePageState extends State<FramePage> {
  String? selectedFrameImagePath;
  String? shape = 'original'; 
  GlobalKey _clipRRectKey = GlobalKey(); 

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (selectedFrameImagePath != null)
                ClipRRect(
                  key: _clipRRectKey, 
                  borderRadius: getClipper(), 
                  child: Image.asset(
                    selectedFrameImagePath!,
                    width: 150,
                    height: 150,
                  ),
                ),
              if (widget.imageFile != null)
                ClipRRect(
                
                  borderRadius: getClipper(), 
                  child: Image.file(
                    widget.imageFile!,
                    width: 150,
                    height: 220,
                  ),
                ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _buildFrameOption('Original', null, 'rectangle'), // Default shape is rectangle
              _buildFrameOption('', 'asset/images/frame1.png', 'heart'),
              _buildFrameOption('', 'asset/images/frame2.png', 'square'),
              _buildFrameOption('', 'asset/images/frame3.png', 'circle'),
              _buildFrameOption('', 'asset/images/frame4.png', 'rectangle'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
               
                  if (widget.onUpdateImage != null) {
                    widget.onUpdateImage!(widget.imageFile!);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal[800],
                ),
                child: const Text(
                  'Use this image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius getClipper() {
    double topLeft = 0.0;
    double topRight = 0.0;
    double bottomLeft = 0.0;
    double bottomRight = 0.0;

    switch (shape) {
      case 'heart':
        topLeft = 500.0;
        topRight = 50.0;
        bottomLeft = 10.0;
        bottomRight = 10.0;
        break;
      case 'rectangle':
        topLeft = 0.0;
        topRight = 0.0;
        bottomLeft = 0.0;
        bottomRight = 0.0;
        break;
      case 'circle':
        topLeft = 100.0;
        topRight = 100.0;
        bottomLeft = 100.0;
        bottomRight = 100.0;
        break;
     
      default:
        topLeft = 0.0;
        topRight = 0.0;
        bottomLeft = 0.0;
        bottomRight = 0.0;
        break;
    }

    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  Widget _buildFrameOption(String label, String? imagePath, String shapeName) {
    return GestureDetector(
      onTap: () {
       
        setState(() {
          selectedFrameImagePath = imagePath;
          shape = shapeName;
        });

      
        _updateClipRRectKey();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10.1),
        child: Container(
          width: 50,
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              if (imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.asset(
                    imagePath,
                    width: 40, 
                    height: 34, 
                  ),
                ),
              Text(
                label,
                style: TextStyle(fontSize: 14), 
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateClipRRectKey() {
    setState(() {
      _clipRRectKey = GlobalKey();
    });
  }
}