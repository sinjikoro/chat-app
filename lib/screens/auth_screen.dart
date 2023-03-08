import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLoading = false;

  void submitFunction({
    required String userName,
    required String emailAddress,
    required String password,
    required bool isLogin,
    required XFile image,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailAddress, password: password);
      } else {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailAddress, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${userCredential.user!.uid}.jpg');

        await ref.putFile(File(image.path));

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': userName,
          'email': emailAddress,
        });
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitFn: submitFunction,
        isLoading: isLoading,
      ),
    );
  }
}
