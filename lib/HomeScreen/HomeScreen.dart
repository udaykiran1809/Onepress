import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_proj/Signup_login/login.dart';
// import 'package:final_proj/Signup_login/Signup.dart';
import 'package:final_proj/group/create_grp.dart';
import 'package:final_proj/group/search_and_join.dart';
import 'package:final_proj/group/display_joined_grp.dart';
import 'package:final_proj/Help/help.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get _user => _auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome, ${_user?.email ?? 'User'}!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HelpPage()));
              },
              child: Text('Help'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateGroupPage()));
              },
              child: Text('Display Joined Group'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JoinedGroupsPage()));
              },
              child: Text('Create Group'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchGroupPage()));
              },
              child: Text('Search a Group'),
            ),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    await _auth.signOut();
    // Navigate back to the login screen after logout
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
