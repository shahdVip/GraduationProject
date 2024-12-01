import 'package:grad_roze/pages/cameraPage/MatchingPage.dart';

import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:palette_generator/palette_generator.dart';
import 'package:image/image.dart' as img;

import 'camera_page_model.dart';
export 'camera_page_model.dart';

class CameraPageWidget extends StatefulWidget {
  const CameraPageWidget({super.key});

  @override
  State<CameraPageWidget> createState() => _CameraPageWidgetState();
}

class _CameraPageWidgetState extends State<CameraPageWidget> {
  late CameraPageModel _model;

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessingImage = false;
  int _selectedCameraIndex = 0;

  final double rectWidthRatio = 0.6; // Width ratio of the rectangle
  final double rectHeightRatio = 0.6; // Height ratio of the rectangle

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CameraPageModel());
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _startCamera(_selectedCameraIndex);
      }
    } catch (e) {
      _showErrorDialog("Camera Initialization Failed", e.toString());
    }
  }

  Future<void> _startCamera(int cameraIndex) async {
    try {
      setState(() => _isCameraInitialized = false);
      _cameraController = CameraController(
        _cameras![cameraIndex],
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      _showErrorDialog("Camera Start Failed", e.toString());
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.isEmpty) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    await _startCamera(_selectedCameraIndex);
  }

  Future<void> _captureAndProcessImage() async {
    if (!_isCameraInitialized || _cameraController == null) return;

    setState(() => _isProcessingImage = true);

    try {
      final XFile imageFile = await _cameraController!.takePicture();
      await _processImage(imageFile.path);
    } catch (e) {
      _showErrorDialog("Capture Error", e.toString());
    } finally {
      setState(() => _isProcessingImage = false);
    }
  }

  Future<void> _processImage(String imagePath) async {
    final img.Image? originalImage =
        img.decodeImage(File(imagePath).readAsBytesSync());

    if (originalImage == null) {
      _showErrorDialog("Processing Error", "Unable to decode the image.");
      return;
    }

    // Calculate rectangle dimensions relative to the image
    final int rectWidth = (originalImage.width * rectWidthRatio).toInt();
    final int rectHeight = (originalImage.height * rectHeightRatio).toInt();
    final int rectLeft = (originalImage.width - rectWidth) ~/ 2;
    final int rectTop = (originalImage.height - rectHeight) ~/ 2;

    // Crop the region inside the rectangle
    final img.Image croppedImage = img.copyCrop(
      originalImage,
      x: rectLeft,
      y: rectTop,
      width: rectWidth,
      height: rectHeight,
    );

    // Use PaletteGenerator on the cropped region
    final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
      MemoryImage(img.encodeJpg(croppedImage)),
    );

    final Color? dominantColor = palette.dominantColor?.color;

    if (dominantColor != null) {
      _showMatchResult(dominantColor, imagePath);
    } else {
      _showErrorDialog("Color Detection Failed", "No dominant color detected.");
    }
  }

  void _showMatchResult(Color dominantColor, String imagePath) {
    Map<String, List<Color>> bouquets = {
      "red": [
        const Color(0xFFFF0000), // Bright red
        const Color(0xFFB22222), // Firebrick
        const Color(0xFF8B0000), // Dark red
        const Color.fromARGB(255, 158, 19, 30), // Tomato
        const Color(0xFFDC143C), // Crimson
        const Color(0xFF770404),
      ],
      "yellow": [
        const Color(0xFFFFFF00), // Yellow
        const Color(0xFFFFD700), // Gold
        const Color(0xFFF0E68C), // Khaki
        const Color(0xFFFFE135), // Banana yellow
        const Color(0xFFFFF8DC), // Cornsilk
      ],
      "pink": [
        const Color(0xFFFFC0CB), // Light pink
        const Color(0xFFFF69B4), // Hot pink
        const Color.fromARGB(255, 235, 7, 83), // Pale violet red
        const Color.fromARGB(255, 201, 9, 73), // Sandy pink
        const Color(0xFFFF1493), // Deep pink
      ],
      "green": [
        const Color(0xFF008000), // Green
        const Color(0xFF32CD32), // Lime green
        const Color(0xFF006400), // Dark green
        const Color(0xFF228B22), // Forest green
        const Color(0xFF7CFC00), // Lawn green
        const Color(0xFF98FB98), // Pale green
      ],
      "blue": [
        const Color(0xFF0000FF), // Blue
        const Color(0xFF4682B4), // Steel blue
        const Color(0xFF1E90FF), // Dodger blue
        const Color(0xFF87CEFA), // Light sky blue
        const Color(0xFF6495ED), // Cornflower blue
        const Color(0xFF4169E1), // Royal blue
      ],
      "white": [
        const Color(0xFFFFFFFF), // White
        const Color(0xFFFAF9F6), // Off-white
        const Color(0xFFEEE9E9), // Snow white
        const Color(0xFFF5F5DC), // Beige
        const Color(0xFFF8F8FF),
        const Color.fromARGB(255, 143, 143, 143),
        const Color.fromARGB(255, 197, 197, 197), // Ghost white
      ],
      "purple": [
        const Color(0xFF800080), // Purple
        const Color(0xFF9370DB), // Medium purple
        const Color(0xFF4B0082), // Indigo
        const Color(0xFFBA55D3), // Orchid
        const Color.fromARGB(255, 185, 32, 185), // Thistle
        const Color(0xFF8A2BE2), // Blue violet
      ],
      "orange": [
        const Color(0xFFFFA500), // Orange
        const Color(0xFFFF4500), // Orange red
        const Color.fromARGB(255, 226, 149, 76), // Coral
        const Color(0xFFFF6347), // Tomato
        const Color.fromARGB(255, 253, 91, 27), // Light salmon
        const Color.fromARGB(255, 122, 96, 37),
      ],
    };

    String bestMatch = "";
    double bestDistance = double.infinity;

    bouquets.forEach((colorName, colorList) {
      for (Color bouquetColor in colorList) {
        double distance = _colorDistance(dominantColor, bouquetColor);
        if (distance < bestDistance) {
          bestDistance = distance;
          bestMatch = colorName;
        }
      }
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Bouquet Match"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(imagePath), height: 150, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(
              "Best match: $bestMatch",
              style: TextStyle(
                fontSize: 18,
                color: dominantColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MatchingPageWidget(color: bestMatch),
                    ),
                  );
                },
                label: Text(
                  "See The Matching Bouquets",
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Funnel Display',
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Set your desired radius
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                label: Text(
                  "OK",
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Funnel Display',
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Set your desired radius
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _colorDistance(Color a, Color b) {
    return ((a.red - b.red).abs() +
            (a.green - b.green).abs() +
            (a.blue - b.blue).abs())
        .toDouble();
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          "Match With Your Bouquet",
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Funnel Display',
                color: FlutterFlowTheme.of(context).primary,
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          if (_isCameraInitialized)
            Expanded(
              child: Stack(
                alignment: Alignment.center, // Center everything in the stack
                children: [
                  CameraPreview(_cameraController!), // Camera feed
                  CustomPaint(
                    size: Size.infinite,
                    painter: RectangleOverlayPainter(), // Overlay rectangle
                  ),
                ],
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      _isProcessingImage ? null : _captureAndProcessImage,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text(
                    "Capture",
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Funnel Display',
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Set your desired radius
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _switchCamera,
                  icon: const Icon(Icons.switch_camera),
                  label: Text(
                    "Switch Camera",
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Funnel Display',
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Set your desired radius
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RectangleOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final double rectWidth = size.width * 0.6;
    final double rectHeight = size.height * 0.6;

    final Rect rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: rectWidth,
      height: rectHeight,
    );

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
