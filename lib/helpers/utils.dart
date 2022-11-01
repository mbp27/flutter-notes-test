import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutternotestest/helpers/colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MyUtils {
  /// This function for load single image from gallery or camera.
  static Future<XFile?> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      return pickedFile;
    } catch (e) {
      rethrow;
    }
  }

  /// Generate md5
  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  /// This function for cropping image file. Param [filePath] is required.
  static Future<CroppedFile?> cropImage({
    required String filePath,
    int? maxHeight,
    int? maxWidth,
    CropAspectRatio? aspectRatio =
        const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    CropStyle cropStyle = CropStyle.rectangle,
    String? toolbarTitle,
  }) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: aspectRatio,
      cropStyle: cropStyle,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      uiSettings: [
        AndroidUiSettings(
          activeControlsWidgetColor: MyColors.pallete,
          dimmedLayerColor: const Color(0xFFBDC4CA).withOpacity(0.7),
          toolbarColor: Colors.white,
          cropFrameColor: Colors.transparent,
          showCropGrid: false,
          toolbarTitle: toolbarTitle,
          initAspectRatio: CropAspectRatioPreset.original,
        ),
      ],
    );
    return cropped;
  }

  /// This function for saving image to application path
  static Future<File> saveFile(
      {required File file, required String filename}) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final newPath = await file.copy('${dir.path}/$filename');
      return newPath;
    } catch (e) {
      rethrow;
    }
  }

  /// This function for compare two date
  static bool isSameDate(DateTime one, DateTime other) {
    return one.year == other.year &&
        one.month == other.month &&
        one.day == other.day;
  }
}
