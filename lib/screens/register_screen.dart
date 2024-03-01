import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/controllers/auth_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

final _formKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _displayNameController = TextEditingController();
final ImagePicker _picker = ImagePicker();
XFile? _profilePicture;

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    _emailController.addListener(() {
      authController.email.value = _emailController.text;
    });

    _passwordController.addListener(() {
      authController.password.value = _passwordController.text;
    });

    _displayNameController.addListener(() {
      authController.displayName.value = _displayNameController.text;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Obx(() {
        if (authController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _profilePicture = image;
                            authController.profilePicture.value =
                                _profilePicture!;
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _profilePicture != null
                            ? FileImage(File(_profilePicture!.path))
                            : null,
                        child: _profilePicture == null
                            ? const Icon(Icons.camera_alt, size: 50)
                            : null,
                      ),
                    ),
                    TextFormField(
                      controller: _displayNameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    FilledButton.icon(
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(200, 50)),
                      ),
                      icon: const Icon(Icons.login),
                      label: const Text('Register'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authController.createAccount();
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(200, 50)),
                      ),
                      icon: const Icon(Icons.login),
                      label: const Text('Or Sign in with Google'),
                      onPressed: () {
                        authController.signInWithGoogle();
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/login');
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
