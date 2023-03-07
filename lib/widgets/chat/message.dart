import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data?.docs;
        print(chatDocs?.length ?? -1);
        return ListView.builder(
          itemCount: chatDocs?.length ?? 0,
          itemBuilder: (context, index) => Text(
            chatDocs?[index]['text'] ?? '',
          ),
        );
      },
    );
  }
}
