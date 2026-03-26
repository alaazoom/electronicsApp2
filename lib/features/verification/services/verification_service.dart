import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class VerificationService {
  Future<bool> validateIdCard(String imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(imagePath);
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      await textRecognizer.close();
      String text = recognizedText.text.trim();
      if (text.isEmpty) {
        return false;
      }
      if (text.length < 10) {
        return false;
      }
      print(
        "✅ ID Text Detected: ${text.substring(0, text.length > 50 ? 50 : text.length)}...",
      );

      return true;
    } catch (e) {
      print("Error in ID validation: $e");
      return false;
    }
  }

  Future<bool> validateSelfie(String imagePath) async {
    final options = FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    );
    final faceDetector = FaceDetector(options: options);
    final inputImage = InputImage.fromFilePath(imagePath);
    try {
      final List<Face> faces = await faceDetector.processImage(inputImage);
      await faceDetector.close();
      if (faces.isEmpty) {
        return false;
      }
      if (faces.length > 1) {
        return false;
      }
      final Face face = faces.first;
      if (face.headEulerAngleY! > 15 || face.headEulerAngleY! < -15) {
        return false;
      }
      return true;
    } catch (e) {
      print("Error in face detection: $e");
      return false;
    }
  }

  Future<String?> compressImage(String path) async {
    final targetPath = path.replaceFirst('.jpg', '_compressed.jpg');
    try {
      var result = await FlutterImageCompress.compressAndGetFile(
        path,
        targetPath,
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );
      return result?.path;
    } catch (e) {
      print("Error compressing image: $e");
      return null;
    }
  }
}
