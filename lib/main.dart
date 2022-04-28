import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task3_twitter/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task3_twitter/screens/tweet_screen.dart';
import 'package:task3_twitter/api/user_sheet_api.dart';
import 'widgets/profile_posts.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await userSheetApi.init();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.blue,
        accentColor: Colors.white70,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
        routes: {
        '/tweetscreen' : (context) => const TweetScreen(),
          '/profile': (context) => Profile(),
        },
        home:
      StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (ctx, userSnapshot) {
    if(userSnapshot.hasData){
      print('Entering tweet');
    return TweetScreen();
    }
    print('Entering auth');
    return AuthScreen();

    }

    ),);
  }
}
