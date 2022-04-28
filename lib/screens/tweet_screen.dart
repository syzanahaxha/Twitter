import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task3_twitter/widgets/drawer/app_drawer.dart';
import 'package:task3_twitter/widgets/tweet/tweet_form.dart';
import 'package:task3_twitter/widgets/users/user_widget.dart';
import '../widgets/tweet/tweet_widget.dart';

class TweetScreen extends StatefulWidget {
  const TweetScreen({Key? key}) : super(key: key);

  @override
  _TweetScreenState createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  final routeName = 'tweetscreen';
  var isPressed = false;
  var isPosting = false;
  File? _pickedImage;

  void pickImage() async {
    final picker = ImagePicker();
    var pickedImageFile = await picker.getImage(
      source: ImageSource.camera,
    );
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,

      appBar: !isPosting
          ? AppBar(

              backgroundColor: Colors.white,
              leading: Builder(
                builder: (context) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.grey,
                          size: 35,
                        ),
                      ),
                    ],
                  );
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 230,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (ctx) => UserWidget()))
                              .then((value) {
                            if (value as bool) {
                              setState(() {});
                            }
                          });
                        },
                        child: Image.network(
                            'https://img.icons8.com/color/50/000000/twitter.png'),
                      ),
                    ),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      setState(
                        () {
                          isPressed = !isPressed;
                        },
                      );
                    },
                    textColor: isPressed ? Colors.grey : Colors.yellow,
                    icon: Icon(Icons.auto_awesome_outlined),
                    label: Text(''),
                  ),
                ],
              ),
            )
          : null,
      drawer: AppDrawer(),
      body: isPosting ? TweetForm(_pickedImage, isPosting) : Tweet(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: !isPosting
            ? Icon(Icons.add)
            : Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
        onPressed: () {
          isPosting
              ? pickImage()
              : setState(() {
                  isPosting = true;
                });
        },
      ),
    );
  }
}
