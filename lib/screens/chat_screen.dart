import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/6zqHq1d62r1Dr3fNIHfA/message')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text('This works!'),
              );
            }
            final docment = snapshot.data?.docs;
            return ListView.builder(
              itemCount: docment?.length ?? 0,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(8),
                height: 30,
                child: Text(docment?[index]['text']),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/6zqHq1d62r1Dr3fNIHfA/message')
              .add({'text': 'this is test!!!'});
        },
      ),
    );
  }
}
