import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({Key? key}) : super(key: key);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  bool isFollower = false;
  String follower = '';
  bool isPressed = false;
  bool isChanged = false;

  void followButton() {
    isFollower = !isFollower;
  }

  void followUser() async {
    final user = await FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    print(userData['uid']);
    if (isPressed) {
      FirebaseFirestore.instance.collection('users').doc(follower).set({
        'followers': FieldValue.arrayUnion([userData['uid']]),
      }, SetOptions(merge: true));
    } else {
      FirebaseFirestore.instance.collection('users').doc(follower).set({
        'followers': FieldValue.arrayRemove([userData['uid']]),
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Expanded(
            child: SizedBox(
              width: 150,
              height: 50,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, isChanged);
                },
                child: Image.network(
                    'https://img.icons8.com/color/50/000000/twitter.png'),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapshot.data?.docs;

          return ListView.builder(
            itemCount: documents?.length,
            itemBuilder: (ctx, index) {
              isFollower = (documents?[index]['followers'] as List)
                  .contains(FirebaseAuth.instance.currentUser!.uid);
              print(isFollower);

              return Card(
                elevation: 0.5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    documents?[index]['imageUrl'],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  documents?[index]['username'],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: !isFollower
                                ? Icon(
                                    Icons.favorite_border,
                                    color: Colors.blueAccent,
                                  )
                                : Icon(
                                    Icons.favorite,
                                    color: Colors.blue,
                                  ),
                            onPressed: () {
                              // setState(() {
                                isPressed = !isPressed;
                                isFollower = true;
                                isChanged = true;
                                follower = documents?[index]['uid'];
                                followUser();
                              // });

                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
