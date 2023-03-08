import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.ImagePickFn});

  final void Function(XFile? pickedImage) ImagePickFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile? imageFile;

  picImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = pickedImage;
    });
    widget.ImagePickFn(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              imageFile != null ? FileImage(File(imageFile!.path)) : null,
          backgroundColor: Colors.grey,
        ),
        TextButton.icon(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor)),
          onPressed: picImage,
          icon: const Icon(Icons.image),
          label: const Text('add image'),
        ),
      ],
    );
  }
}
