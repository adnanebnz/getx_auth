import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    _emailController.addListener(() {
      authController.email.value = _emailController.text;
    });

    _passwordController.addListener(() {
      authController.password.value = _passwordController.text;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                      label: const Text('Login'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authController.signInWithEmailAndPassword(
                            authController.email.value,
                            authController.password.value,
                          );
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
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/register');
                          },
                          child: const Text('Register'),
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
