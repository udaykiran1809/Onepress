import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_proj/chat/chat_page.dart';

class JoinedGroupsPage extends StatefulWidget {
  @override
  _JoinedGroupsPageState createState() => _JoinedGroupsPageState();
}

class _JoinedGroupsPageState extends State<JoinedGroupsPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groups'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .where('members', arrayContains: user?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var groups = snapshot.data!.docs;

          if (groups.isEmpty) {
            return Center(child: Text("You haven't joined any groups yet."));
          }

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              var group = groups[index];

              return ListTile(
                title: Text(group['name']),
                onTap: () {
                  // Navigate to group chat page
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupChatPage(
                        groupId: group.id, groupName: group['name']),
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
