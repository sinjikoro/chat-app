import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.submitFn, required this.isLoading});

  final bool isLoading;

  final void Function({
    required String userName,
    required String emailAddress,
    required String password,
    required bool isLogin,
  }) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final formKey = GlobalKey<FormState>();
  var isLogin = true;
  var userName = '';
  var userAddress = '';
  var userPassword = '';

  void trySubmit() {
    final isValid = formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      formKey.currentState!.save();

      widget.submitFn(
        userName: userName.trim(),
        emailAddress: userAddress.trim(),
        password: userPassword.trim(),
        isLogin: isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter email address.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    userAddress = newValue ?? '';
                  },
                ),
                if (!isLogin)
                  TextFormField(
                    key: const ValueKey('userName'),
                    decoration: const InputDecoration(labelText: 'UserName'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'user name needs 4 char.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      userName = newValue ?? '';
                    },
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return 'password needs 8 char.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    userPassword = newValue ?? '';
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: trySubmit,
                    child: Text(isLogin ? 'Login' : 'Sign up'),
                  ),
                if (!widget.isLoading)
                  TextButton(
                    onPressed: () => setState(() {
                      isLogin = !isLogin;
                    }),
                    child: Text(
                        isLogin ? 'Create new account' : 'Already get account'),
                  ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
