
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task3_twitter/widgets/pickers/post_image_picker.dart';

import '../../screens/tweet_screen.dart';

class TweetForm extends StatefulWidget {
  TweetForm(this.pickedImage, this.isPosting);

  final File? pickedImage;
  final bool isPosting;

  @override
  _TweetFormState createState() => _TweetFormState();
}

class _TweetFormState extends State<TweetForm> {
  final _controller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _description = '';
  String userId = '';


  void _saveData() async {
    final user = await FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final ref = FirebaseStorage.instance.ref().child('tweet_image');

    final url = await ref
        .putFile(widget.pickedImage!)
        .then((p0) => p0.ref.getDownloadURL());

    if (!_description.isEmpty) {
      Navigator.of(context, rootNavigator: true).pop(context);
      Navigator.pushNamed(context, '/tweetscreen');
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => TweetScreen()));

      DocumentReference  post = FirebaseFirestore.instance.collection('post').doc();

      post.set({
        'postId':  post.id,
        'description': _description,
        'Category': 'Technology',
        'postImage': url,
        'userImage': userData['imageUrl'],
        'username': userData['username'],
        'userId': userData['uid'],
        'likes': [],
        'createdAt': Timestamp.now(),
      });
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop(context);
                              Navigator.pushNamed(context, '/tweetscreen');
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          RaisedButton(
                            onPressed: _saveData,
                            child: Text('Tweet'),
                          ),
                        ],
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLength: 50,
                        controller: _controller,
                        key: ValueKey('description'),
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          // focusColor: Colors.black,
                          icon: new Icon(
                            Icons.account_circle,
                            size: 30,
                          ),
                          labelText: "What's happening?",
                        ),
                        onChanged: (value) {
                          _description = value;
                        },
                      ),
                      Container(
                        width: 200,
                        height: 300,
                        child: CircleAvatar(
                          
                          backgroundColor: Colors.white,
                          backgroundImage: widget.pickedImage != null
                              ? FileImage(widget.pickedImage!)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
