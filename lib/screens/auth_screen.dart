import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void submitFunction({
    required String userName,
    required String emailAddress,
    required String password,
    required bool isLogin,
  }) async {
    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailAddress, password: password);
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailAddress, password: password);
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitFn: submitFunction,
      ),
    );
  }
}
