import 'package:flutter/material.dart';

class PostImagePicker extends StatefulWidget {
  const PostImagePicker({Key? key}) : super(key: key);

  @override
  _PostImagePickerState createState() => _PostImagePickerState();
}

class _PostImagePickerState extends State<PostImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          // backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        FlatButton.icon(
          onPressed: (){},
          icon: Icon(Icons.image),
          label: Text(''),
        ),

      ],
    );
  }
}
