import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../profile_posts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userData =
        FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: user.uid).snapshots(),
      builder: (context, streamSnapshot) {
        final documents = streamSnapshot.data?.docs[0];
        return Drawer(
            child: Column(
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    documents?['imageUrl'],
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  documents?['username'],
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 23),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Lists'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.bookmark_border_outlined),
              title: Text('Bookmarks'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.request_page),
              title: Text('Follower requests'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.message_sharp),
              title: Text('Twitter For Professionals'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Settings and privacy'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Help Center'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Log out'),
              onTap: () {
                print('signing out...');
                FirebaseAuth.instance.signOut();
                print('signing out ends...');
              },
            ),
          ],
        ));
      },
    );
  }
}
