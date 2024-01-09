// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:instagram_app_cool/resources/auth_methods.dart';
import 'package:instagram_app_cool/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const pageRouteName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  login() async {
    String msg = await AuthMethods().login(
        email: _emailController.text, password: _passwordController.text);

    if (msg == "") {
      showSnackBar(context, 'Login effettuato');
    } else {
      showSnackBar(context, msg);
      print(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Instagram',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              padding: const EdgeInsets.all(32),
              child: Form(
                  child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Email..', border: OutlineInputBorder())),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Password', border: OutlineInputBorder())),
                  const SizedBox(
                    height: 32,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      child: const Text('Login'))
                ],
              )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    'Non hai un account?',
                  ),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      ' Registrati.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
