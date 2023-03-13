import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data?.docs;
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs?.length ?? 0,
          itemBuilder: (context, index) => MessageBubble(
            key: ValueKey(chatDocs?[index].id),
            message: chatDocs?[index]['text'] ?? '',
            isMe: chatDocs?[index]['userId'] == userId,
            userName: chatDocs?[index]['userName'],
            userIamge: chatDocs?[index]['userImage'],
          ),
        );
      },
    );
  }
}
