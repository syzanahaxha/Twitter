import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tweet extends StatefulWidget {
  @override
  _TweetState createState() => _TweetState();
}

class _TweetState extends State<Tweet> {
  var isPressed = false;
  var hasImage = false;
  var like = '';
  var isLiked = false;
  var isFollowed = false;
  var follower = '';

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

  Future<List> getFollowers() async {
    QuerySnapshot userFollower = await FirebaseFirestore.instance
        .collection('users')
        .where('followers',
            arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .get();
    print('followers:');
    List followedUsersIds = userFollower.docs.map((e) => e['uid']).toList();
    print(followedUsersIds);
    return followedUsersIds;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getFollowers(),
        builder: (context, snapShots) => StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('post')
                  .where('userId',
                      whereIn:
                          snapShots.data!.isNotEmpty ? snapShots.data : [''])
                  .snapshots(),
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
                      isLiked = (documents?[index]['likes'] as List)
                          .contains(FirebaseAuth.instance.currentUser!.uid);
                      print(isLiked);
                      return Card(
                        elevation: 0.5,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 4, 15, 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.message),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 0, 0),
                                              child: Text(documents?[index]
                                                  ['Category']),
                                            ),
                                          ),
                                          FlatButton(
                                            onPressed: () {},
                                            child: Text('See more'),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  documents?[index]
                                                      ['userImage']),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    SizedBox(
                                                      width: 125,
                                                      child: Text(
                                                        '@' +
                                                            documents?[index]
                                                                ['username'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 6, 0, 0),
                                                  child: Text(documents?[index]
                                                      ['description']),
                                                ),
                                                if (!hasImage)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 6, 0, 0),
                                                    child: SizedBox(
                                                      width: 200,
                                                      height: 100,
                                                      child: Image.network(
                                                        documents?[index]
                                                            ['postImage'],
                                                        fit: BoxFit.cover,
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
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.comment_outlined,
                                                  size: 25,
                                                ),
                                                color: Colors.grey),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.cached,
                                                  size: 25,
                                                ),
                                                color: Colors.grey),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                isLiked = true;
                                                isPressed = !isPressed;
                                                like =
                                                    documents?[index]['postId'];
                                                likePost();
                                                print(like);
                                              },
                                              icon: !isLiked
                                                  ? Icon(
                                                      Icons
                                                          .favorite_outline_rounded,
                                                      size: 25,
                                                    )
                                                  : Icon(
                                                      Icons.favorite,
                                                      color: Colors.blue,
                                                      size: 25,
                                                    ),
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.file_upload_outlined,
                                                  size: 25,
                                                ),
                                                color: Colors.grey),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              },
            ));
  }
}
