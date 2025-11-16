import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/theme/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FormInputPhoto extends ConsumerStatefulWidget {
  const FormInputPhoto({super.key, required this.onImagePicked});
  final ValueChanged<File> onImagePicked;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FormInputPhoto();
  }
}

class _FormInputPhoto extends ConsumerState<FormInputPhoto> {
  File? _selectedImage;
  void _takePhoto() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
      widget.onImagePicked(_selectedImage!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePhoto,
      label: const Text('Prendre une photo'),
      icon: Icon(Icons.photo_camera),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePhoto,
        child: Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity),
      );
    }

    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1, color: colorScheme.primary)),
      height: 150,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
