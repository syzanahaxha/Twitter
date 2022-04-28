import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var isPressed = false;
  var hasImage = false;
  var like = '';
  var isLiked = false;
  var showMedia = true;
  var showMessage = true;

  void likePost() async {
    final user = await FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (isPressed) {
      FirebaseFirestore.instance.collection('post').doc(like).set({
        'likes': FieldValue.arrayUnion([userData['uid']]),
      }, SetOptions(merge: true));
    } else {
      FirebaseFirestore.instance.collection('post').doc(like).set({
        'likes': FieldValue.arrayRemove([userData['uid']]),
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid',
                isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final document = streamSnapshot.data?.docs[0];
              return
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 6, 25, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  document?['imageUrl'],
                                ),
                              ),
                            ),
                            RaisedButton(
                              color: Colors.white,
                              onPressed: () {},
                              child: Text('Set up profile'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 0, 0),
                        child: Text(document?['username'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          '@SyzanaHaxha',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_view_month,
                              color: Colors.grey,
                            ),
                            Text(
                              'Joined February 2022',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 15, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              '21 Following',
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                '1 Follower',
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.,
                          children: [
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  showMedia = false;
                                  showMessage = true;
                                });
                              },
                              child: Text(
                                'Tweet',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  showMedia = false;
                                  showMessage = true;
                                });
                              },
                              child: Text(
                                'Tweet & relies',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  showMedia = true;
                                  showMessage = false;
                                });
                              },
                              child: Text(
                                'Media',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  showMedia = false;
                                  showMessage = true;
                                });
                              },
                              child: Text(
                                'Likes',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  );
                },
              ),
              // ],

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('post')
                .where('userId',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documents = streamSnapshot.data?.docs;

              return Expanded(child: ListView.builder(
                itemCount: documents?.length,
                itemBuilder: (ctx, index) {
                  isLiked = (documents?[index]['likes'] as List)
                      .contains(FirebaseAuth.instance.currentUser!.uid);
                  print(isLiked);
                  return
                        Card(
                          elevation: 0.5,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (!hasImage)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 6, 0, 0),
                                                      child: Expanded(
                                                        child: Center(
                                                          child: Expanded(
                                                            child: SizedBox(
                                                              width: 270,
                                                              height: 200,
                                                              child: Expanded(
                                                                child: Image
                                                                    .network(
                                                                  documents?[
                                                                          index]
                                                                      [
                                                                      'postImage'],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 80,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        );




                },
              ),);
              // ],
            },
          ),
        ],
      ),
    );
  }
}
