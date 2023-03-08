import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String enterMessage = '';
  final textController = TextEditingController();

  void sendMessage() async {
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': enterMessage,
      'userId': user?.uid ?? '',
      'userName': userData['username'],
      'createAt': Timestamp.now(),
    });
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: textController,
            decoration: const InputDecoration(labelText: 'Send a message ...'),
            onChanged: (value) {
              setState(() {
                enterMessage = value;
              });
            },
          ),
        ),
        IconButton(
          onPressed: enterMessage.trim().isEmpty ? null : sendMessage,
          style: ButtonStyle(
              iconColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor)),
          icon: const Icon(Icons.send),
        ),
      ]),
    );
  }
}
