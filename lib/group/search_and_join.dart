import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchGroupPage extends StatefulWidget {
  @override
  _SearchGroupPageState createState() => _SearchGroupPageState();
}

class _SearchGroupPageState extends State<SearchGroupPage> {
  final TextEditingController _searchController = TextEditingController();
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  void joinGroup(String groupId) async {
    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("You're not logged in")));
      return;
    }

    final DocumentReference groupRef =
        FirebaseFirestore.instance.collection('groups').doc(groupId);

    final DocumentSnapshot groupDoc = await groupRef.get();

    if (groupDoc.exists) {
      List<dynamic> members = groupDoc['members'] ?? [];
      if (!members.contains(userId)) {
        await groupRef.update({
          'members': FieldValue.arrayUnion([userId])
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Joined the group successfully")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You're already a member of this group")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Group'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for groups...',
                suffixIcon: IconButton(
                  onPressed: _searchController.clear,
                  icon: Icon(Icons.clear),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .where('name', isGreaterThanOrEqualTo: _searchController.text)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                return ListView(
                  children: snapshot.data!.docs
                      .map((doc) => ListTile(
                            title: Text(doc['name']),
                            onTap: () => joinGroup(doc.id),
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
