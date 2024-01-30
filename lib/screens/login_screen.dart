// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app_cool/resources/auth_methods.dart';
import 'package:instagram_app_cool/utils/styles.dart';
import 'package:instagram_app_cool/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, this.reauthenticate = false});

  static const pageRouteName = '/login';
  bool reauthenticate = false;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  void loginUtente() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    // if string returned is sucess, user has been created
    if (res == "") {
      // if (context.mounted) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // }
      // navigate to the home screen
      showSnackBar(context, 'Login effettuato');

      // if (context.mounted) {
      //   Future.delayed(const Duration(seconds: 1), () {
      //     Navigator.of(context).pushReplacementNamed('/main');
      //   });
      // }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
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
                        key: _formKey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.reauthenticate
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'Esegui l\'Accesso per confermare l\'azione'),
                                  )
                                : Container(),
                            TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration:
                                    textFieldDecoration(label: 'Email')),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: textFieldDecoration(label: 'Password')),
                            const SizedBox(
                              height: 32,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  // loginUtente();
                                  if (_formKey.currentState!.validate()) {
                                    loginUtente();
                                  }
                                },
                                child: const Text('Login'))
                          ],
                        )),
                  ),
                  widget.reauthenticate
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text(
                                'Non hai un account?',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/register',
                                )
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
