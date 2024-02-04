import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final user = FirebaseAuth.instance.currentUser;

  void sendHelpMessage() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enable Location Services')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location permissions are denied')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _sendMessageToAllGroups(position);
  }

  Future<void> _sendMessageToAllGroups(Position position) async {
    final user = FirebaseAuth.instance.currentUser;
    final groupsQuerySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('members', arrayContains: user?.uid)
        .get();

    for (var group in groupsQuerySnapshot.docs) {
      FirebaseFirestore.instance
          .collection('groups')
          .doc(group.id)
          .collection('messages')
          .add({
        'text':
            'Help!!! I am here: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}',
        'createdAt': Timestamp.now(),
        'userId': user?.uid,
      });
    }

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Help message sent to all groups')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Help Message'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Press the button below to send a "Help!!!" message to all groups you are a member of.',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton.icon(
              onPressed: sendHelpMessage,
              icon: Icon(Icons.warning_amber_rounded),
              label: Text('Send Help!!!'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Button color
                onPrimary: Colors.white, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
