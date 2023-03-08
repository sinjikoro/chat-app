import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.submitFn, required this.isLoading});

  final bool isLoading;

  final void Function({
    required String userName,
    required String emailAddress,
    required String password,
    required bool isLogin,
    required XFile image,
  }) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userName = '';
  var _userAddress = '';
  var _userPassword = '';
  XFile? _userImageFile;

  void _pickedImage(XFile? image) {
    _userImageFile = image;
  }

  void trySubmit() {
    final isValid = formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (_userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (isValid) {
      formKey.currentState!.save();

      widget.submitFn(
        userName: _userName.trim(),
        emailAddress: _userAddress.trim(),
        password: _userPassword.trim(),
        isLogin: _isLogin,
        image: _userImageFile!,
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
                if (!_isLogin)
                  UserImagePicker(
                    ImagePickFn: _pickedImage,
                  ),
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
                    _userAddress = newValue ?? '';
                  },
                ),
                if (!_isLogin)
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
                      _userName = newValue ?? '';
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
                    _userPassword = newValue ?? '';
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: trySubmit,
                    child: Text(_isLogin ? 'Login' : 'Sign up'),
                  ),
                if (!widget.isLoading)
                  TextButton(
                    onPressed: () => setState(() {
                      _isLogin = !_isLogin;
                    }),
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'Already get account'),
                  ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
