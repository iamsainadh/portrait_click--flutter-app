import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

selectImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }

  
}

showSnackBar(
  BuildContext context,
  String content,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
