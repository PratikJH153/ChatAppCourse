import 'dart:io';

import 'package:chatapp/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

enum AuthMode {
  signup,
  signin,
}

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    AuthMode authMode,
    File image,
    BuildContext ctx,
  ) submitFn;
  final bool isLoading;
  const AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  File? _userImageFile;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AuthMode _authMode = AuthMode.signin;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _submit(BuildContext ctx) {
    final form = _formKey.currentState;
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && _authMode == AuthMode.signup) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text("Please pick an image"),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    if (form!.validate()) {
      form.save();
      widget.submitFn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
        _authMode,
        _userImageFile!,
        context,
      );
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.signin) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.signin;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_authMode == AuthMode.signup)
                    Column(
                      children: [
                        UserImagePicker(
                          _pickedImage,
                        ),
                        TextFormField(
                          key: const ValueKey("username"),
                          controller: _usernameController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return "Please enter at least 4 characters.";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: "Username",
                          ),
                        ),
                      ],
                    ),
                  TextFormField(
                    key: const ValueKey("email"),
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                    ),
                  ),
                  TextFormField(
                    key: const ValueKey("password"),
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return "Password must be at least 7 characters long.";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  widget.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () => _submit(context),
                          child: Text(
                            _authMode == AuthMode.signin ? "Login" : "Signup",
                          ),
                        ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: _switchAuthMode,
                      child: Text(_authMode == AuthMode.signin
                          ? "Create new account"
                          : "Login to an existing account."),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
